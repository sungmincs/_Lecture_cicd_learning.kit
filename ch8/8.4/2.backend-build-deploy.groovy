pipeline {
    agent any
    environment {
        DOCKER_REPOSITORY = 'worklog-backend'
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
    }
    stages {
        stage('Init') {
            steps {
                script {
                    env.SHORT_SHA = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                    env.COMMIT_MESSAGE = sh(script: 'git log -1 --pretty=%B', returnStdout: true).trim()
                }
            }
        }
        stage('Run Test') {
            agent {
                docker {
                    image 'python:3.12.3-slim-bookworm'
                    args '-u root'
                }
            }
            steps {
                sh '''
                    pip install poetry
                    poetry install
                    poetry run pytest
                '''
            }
        }
        stage('Build Image') {
            steps {
                sh """
                    docker login -u ${DOCKERHUB_CREDENTIALS_USR} -p ${DOCKERHUB_CREDENTIALS_PSW}
                    docker build -t ${DOCKERHUB_CREDENTIALS_USR}/${DOCKER_REPOSITORY}:${SHORT_SHA} .
                    docker push ${DOCKERHUB_CREDENTIALS_USR}/${DOCKER_REPOSITORY}:${SHORT_SHA}
                """
            }
        }
        stage('Deploy') {
            steps {
                withCredentials([file(credentialsId: 'kube-config', variable: 'KUBECONFIG')]) {
                    sh """
                        kubectl set image deployment/worklog-backend \
                            worklog-backend=${DOCKERHUB_CREDENTIALS_USR}/${DOCKER_REPOSITORY}:${SHORT_SHA}
                    """
                }
            }
        }
    }
    post {
        success { echo "Backend deploy succeeded: ${env.COMMIT_MESSAGE}" }
        failure { echo "Backend deploy failed: ${env.COMMIT_MESSAGE}" }
    }
}
