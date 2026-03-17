pipeline {
    agent any
    environment {
        DOCKER_REPOSITORY = 'worklog-frontend'
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
    }
    stages {
        stage('Init') {
            steps {
                script {
                    env.SHORT_SHA = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                }
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
                        kubectl set image deployment/worklog-frontend \
                            worklog-frontend=${DOCKERHUB_CREDENTIALS_USR}/${DOCKER_REPOSITORY}:${SHORT_SHA}
                    """
                }
            }
        }
    }
    post {
        success { echo 'Frontend pipeline succeeded!' }
        failure { echo 'Frontend pipeline failed!' }
    }
}
