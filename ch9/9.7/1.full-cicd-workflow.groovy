pipeline {
    agent any
    environment {
        DOCKER_REPOSITORY = 'worklog-backend'
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        ARGOCD_SERVER = 'argocd.myk8s.local'
    }
    stages {
        stage('Init') {
            steps {
                script {
                    env.SHORT_SHA = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                    env.COMMIT_MESSAGE = sh(script: 'git log -1 --pretty=%B', returnStdout: true).trim()
                    if (env.TAG_NAME) {
                        env.TARGET_ENV = 'prod'
                        env.ARGOCD_APP = 'worklog-backend-prod'
                    } else if (env.BRANCH_NAME.startsWith('release/')) {
                        env.TARGET_ENV = 'staging'
                        env.ARGOCD_APP = 'worklog-backend-staging'
                    } else {
                        env.TARGET_ENV = 'dev'
                        env.ARGOCD_APP = 'worklog-backend-dev'
                    }
                }
            }
        }
        stage('Test') {
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
        stage('Build') {
            steps {
                sh """
                    docker login -u ${DOCKERHUB_CREDENTIALS_USR} -p ${DOCKERHUB_CREDENTIALS_PSW}
                    docker build -t ${DOCKERHUB_CREDENTIALS_USR}/${DOCKER_REPOSITORY}:${SHORT_SHA} .
                    docker push ${DOCKERHUB_CREDENTIALS_USR}/${DOCKER_REPOSITORY}:${SHORT_SHA}
                """
            }
        }
        stage('Deploy via Argo CD') {
            steps {
                withCredentials([string(credentialsId: 'argocd-password', variable: 'ARGOCD_PASSWORD')]) {
                    sh """
                        argocd login ${ARGOCD_SERVER} --username admin --password ${ARGOCD_PASSWORD} --insecure
                        argocd app set ${ARGOCD_APP} --parameter image.tag=${SHORT_SHA}
                        argocd app sync ${ARGOCD_APP}
                        argocd app wait ${ARGOCD_APP} --health
                    """
                }
            }
        }
    }
    post {
        success { echo "Argo CD deploy to ${env.TARGET_ENV} succeeded" }
        failure { echo "Argo CD deploy to ${env.TARGET_ENV} failed" }
    }
}
