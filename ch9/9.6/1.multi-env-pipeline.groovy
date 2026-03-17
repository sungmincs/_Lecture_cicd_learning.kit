def fullSHA
def shortSHA
def branch
def commitMessage
def targetEnvironment
def targetNamespace
def imageTag

def determineEnvironment() {
    if (env.TAG_NAME && env.TAG_NAME.startsWith('v')) {
        targetEnvironment = 'prod'
        targetNamespace = 'prod'
        imageTag = env.TAG_NAME
    } else if (env.BRANCH_NAME == 'develop') {
        targetEnvironment = 'dev'
        targetNamespace = 'dev'
        imageTag = "dev-${shortSHA}"
    } else if (env.BRANCH_NAME.startsWith('release/')) {
        targetEnvironment = 'staging'
        targetNamespace = 'staging'
        imageTag = "staging-${shortSHA}"
    } else if (env.BRANCH_NAME == 'main') {
        targetEnvironment = 'dev'
        targetNamespace = 'dev'
        imageTag = "dev-${shortSHA}"
    } else {
        targetEnvironment = 'dev'
        targetNamespace = 'dev'
        imageTag = "dev-${shortSHA}"
    }
}

def sendSlackMessage(statusMessage) {
    echo "Pipeline ${statusMessage}"
    echo "Environment: ${targetEnvironment}"
    echo "Namespace: ${targetNamespace}"
    echo "Image Tag: ${imageTag}"
    echo "Commit: ${commitMessage}"
}

pipeline {
    agent any

    environment {
        DOCKER_REPOSITORY = '<dockerhub_username>/worklog-backend'
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        KUBE_CONFIG = credentials('kube-config')
    }

    stages {
        stage('Init Variables') {
            steps {
                script {
                    fullSHA = sh(script: "git log -n 1 --pretty=format:'%H'", returnStdout: true).trim()
                    shortSHA = fullSHA[0..7]
                    branch = env.BRANCH_NAME
                    commitMessage = sh(script: "git log -1 --format='*%s* by _%an_'", returnStdout: true).trim()
                    determineEnvironment()
                    echo "Target Environment: ${targetEnvironment}"
                    echo "Target Namespace: ${targetNamespace}"
                    echo "Image Tag: ${imageTag}"
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
                    echo "Running tests for ${shortSHA} on ${branch}"
                    sh 'pip install poetry'
                    sh 'poetry install --no-root'
                    sh 'export TESTING=true && poetry run coverage run --source ./src/worklog -m pytest --disable-warnings -v'
                    sh 'poetry run coverage report'
                }
            }
        }

        stage('Build Image') {
            steps {
                script {
                    echo "Building image for ${branch} with tag ${imageTag}"
                    sh """
                        echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login --username ${DOCKERHUB_CREDENTIALS_USR} --password-stdin
                        docker build . \
                            -t ${DOCKER_REPOSITORY}:${imageTag} \
                            -t ${DOCKER_REPOSITORY}:${shortSHA}
                        docker push ${DOCKER_REPOSITORY}:${imageTag}
                        docker push ${DOCKER_REPOSITORY}:${shortSHA}
                    """
                    echo "Build successful: ${imageTag}, ${shortSHA}"
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    echo "Deploying ${imageTag} to ${targetNamespace}"
                    sh """
                        mkdir -p ~/.kube
                        cp ${KUBE_CONFIG} ~/.kube/config
                        kubectl set image deployment/worklog-backend \
                            worklog-backend=${DOCKER_REPOSITORY}:${imageTag} \
                            -n ${targetNamespace} || \
                        kubectl create deployment worklog-backend \
                            --image=${DOCKER_REPOSITORY}:${imageTag} \
                            -n ${targetNamespace}
                        kubectl rollout status deployment/worklog-backend -n ${targetNamespace} --timeout=120s
                    """
                    echo "Deployed ${imageTag} to ${targetNamespace}"
                }
            }
        }
    }

    post {
        always {
            echo 'Job finished. Sending notifications ..'
        }
        success {
            echo 'Build Success'
            script { sendSlackMessage('completed') }
        }
        failure {
            echo 'Build Failed'
            script { sendSlackMessage('failed') }
        }
        aborted {
            echo 'Build Aborted'
            script { sendSlackMessage('aborted') }
        }
    }
}
