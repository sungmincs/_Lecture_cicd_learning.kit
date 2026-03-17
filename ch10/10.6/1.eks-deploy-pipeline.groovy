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
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_REGION = 'ap-northeast-2'
        EKS_CLUSTER_NAME = 'cicd-learning-eks'
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
        stage('Configure AWS') {
            steps {
                echo "Configuring AWS credentials and kubeconfig for EKS"
                sh """
                    aws eks update-kubeconfig --region ${AWS_REGION} --name ${EKS_CLUSTER_NAME}
                """
            }
        }
        stage('Deploy to EKS') {
            steps {
                echo "Deploying to EKS with image tag ${shortSHA}"
                sh """
                    cd deploy_manifest
                    sed -i "s|image: .*worklog-backend:.*|image: ${DOCKER_REPOSITORY}:${shortSHA}|" worklog-backend.yaml
                    sed -i "s|value: .*# IMAGE_TAG|value: ${shortSHA} # IMAGE_TAG|" worklog-backend.yaml
                    kubectl apply -f worklog-backend.yaml
                    kubectl rollout status deployment/worklog-backend --timeout=120s
                """
                echo "Deploy to EKS completed for tag ${shortSHA}"
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
