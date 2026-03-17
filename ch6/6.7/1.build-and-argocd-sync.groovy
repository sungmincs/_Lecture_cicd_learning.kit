def fullSHA
def shortSHA
def branch
def commitMessage

def sendSlackMessage(statusMessage, commitMessage, shortSHA, fullSHA) {
    echo "Your pipeline has been ${statusMessage}"
    echo "Commit Message: ${commitMessage}"
    echo "Tags: ${shortSHA}, ${fullSHA}"
}

pipeline {
    agent any
    environment {
        DOCKER_REPOSITORY = '<dockerhub_username>/worklog-backend'
        DOCKERHUB_USERNAME = '<dockerhub_username>'
        DOCKERHUB_TOKEN = credentials('dockerhub-token')
        ARGOCD_SERVER = 'argocd.myk8s.local'
        ARGOCD_APP_NAME = 'worklog-backend'
        ARGOCD_ADMIN_PASSWORD = credentials('argocd-admin-password')
    }
    stages {
        stage('Init Variables') {
            steps {
                script {
                    fullSHA = sh(script: "git log -n 1 --pretty=format:'%H'", returnStdout: true)
                    shortSHA = fullSHA[0..8]
                    branch = env.BRANCH_NAME
                    commitMessage = sh(script: "git log -1 --format='*%s* by _%an_'", returnStdout: true)
                }
            }
        }
        stage('Run Test') {
            agent {
                docker {
                    image 'python:3.12.3-slim-bookworm'
                }
            }
            steps {
                script {
                    echo "let's run a test for ${shortSHA} in ${branch}"
                    echo "running test for ${fullSHA}"
                    sh 'pip install poetry'
                    echo 'Test Passed!'
                }
            }
        }
        stage('Build Image') {
            steps {
                echo "Let's build the image for ${shortSHA} in ${branch}"
                echo "The change commit message to build is '${commitMessage}'"
                sh """
                    echo ${DOCKERHUB_TOKEN} | docker login --username ${DOCKERHUB_USERNAME} --password-stdin
                    docker build . \
                        -t ${DOCKER_REPOSITORY}:${fullSHA} \
                        -t ${DOCKER_REPOSITORY}:${shortSHA}
                    docker push ${DOCKER_REPOSITORY}:${shortSHA}
                    docker push ${DOCKER_REPOSITORY}:${fullSHA}
                """
                echo 'build successful and published image with the following tags:'
                echo "Tags: ${shortSHA}, ${fullSHA}"
            }
        }
        stage('Update Manifest') {
            steps {
                echo "Updating deploy manifest with new image tag ${shortSHA}"
                sh """
                    cd deploy_manifest
                    sed -i "s|image: .*worklog-backend:.*|image: ${DOCKER_REPOSITORY}:${shortSHA}|" worklog-backend.yaml
                    sed -i "s|value: .*# IMAGE_TAG|value: ${shortSHA} # IMAGE_TAG|" worklog-backend.yaml
                    git config user.name "jenkins"
                    git config user.email "jenkins@myk8s.local"
                    git add .
                    git commit -m "deploy: update image tag to ${shortSHA}"
                    git push origin main
                """
            }
        }
        stage('Sync Argo CD') {
            steps {
                echo "Syncing Argo CD application ${ARGOCD_APP_NAME}"
                sh """
                    argocd login ${ARGOCD_SERVER} \
                        --username admin \
                        --password ${ARGOCD_ADMIN_PASSWORD} \
                        --insecure
                    argocd app sync ${ARGOCD_APP_NAME}
                    argocd app wait ${ARGOCD_APP_NAME} --health --timeout 120
                """
                echo "Argo CD sync completed successfully"
            }
        }
    }
    post {
        always {
            echo 'Job finished. Sending slack notifications ..'
        }
        success {
            echo 'Build Success, Notifying to slack..'
            sendSlackMessage('completed', commitMessage, shortSHA, fullSHA)
        }
        failure {
            echo 'Build Failed, Notifying to slack..'
            sendSlackMessage('failed', commitMessage, shortSHA, fullSHA)
        }
        aborted {
            echo 'Build Aborted, Notifying to slack..'
            sendSlackMessage('aborted', commitMessage, shortSHA, fullSHA)
        }
    }
}
