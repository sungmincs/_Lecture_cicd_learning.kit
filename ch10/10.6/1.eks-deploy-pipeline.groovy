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
                    env.FULL_SHA = sh(script: "git log -n 1 --pretty=format:'%H'", returnStdout: true).trim()
                    env.SHORT_SHA = env.FULL_SHA.take(8)
                    env.COMMIT_MESSAGE = sh(script: "git log -1 --format='*%s* by _%an_'", returnStdout: true).trim()
                }
            }
        }
        stage('Run Test') {
            steps {
                sh '''
                    curl -LsSf https://astral.sh/uv/install.sh | sh
                    export PATH="$HOME/.local/bin:$PATH"
                    uv sync --extra dev
                    TESTING=true uv run coverage run --source ./src/worklog -m pytest --disable-warnings -v
                    uv run coverage report
                '''
            }
        }
        stage('Build Image') {
            steps {
                echo "Let's build the image for ${env.SHORT_SHA} in ${env.BRANCH_NAME}"
                echo "The change commit message to build is '${env.COMMIT_MESSAGE}'"
                sh """
                    docker run --privileged --rm tonistiigi/binfmt --install all 2>/dev/null || true
                    docker buildx rm eks-builder 2>/dev/null || true
                    docker buildx create --name eks-builder --driver docker-container --use
                    echo ${DOCKERHUB_TOKEN} | docker login --username ${DOCKERHUB_USERNAME} --password-stdin
                    docker buildx build --platform linux/amd64,linux/arm64 \\
                        -t ${DOCKER_REPOSITORY}:${env.FULL_SHA} \\
                        -t ${DOCKER_REPOSITORY}:${env.SHORT_SHA} \\
                        --push .
                """
                echo 'build successful and published image with the following tags:'
                echo "Tags: ${env.SHORT_SHA}, ${env.FULL_SHA}"
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
                echo "Deploying to EKS with image tag ${env.SHORT_SHA}"
                sh """
                    cd deploy_manifest
                    sed -i "s|image: .*worklog-backend:.*|image: ${DOCKER_REPOSITORY}:${env.SHORT_SHA}|" worklog-backend.yaml
                    sed -i "s|value: .*# IMAGE_TAG|value: ${env.SHORT_SHA} # IMAGE_TAG|" worklog-backend.yaml
                    kubectl apply -f worklog-backend.yaml
                    kubectl rollout status deployment/worklog-backend --timeout=120s
                """
                echo "Deploy to EKS completed for tag ${env.SHORT_SHA}"
            }
        }
    }
    post {
        always {
            echo 'Job finished. Sending slack notifications ..'
        }
        success {
            echo 'Build Success, Notifying to slack..'
            sendSlackMessage('completed', env.COMMIT_MESSAGE, env.SHORT_SHA, env.FULL_SHA)
        }
        failure {
            echo 'Build Failed, Notifying to slack..'
            sendSlackMessage('failed', env.COMMIT_MESSAGE, env.SHORT_SHA, env.FULL_SHA)
        }
        aborted {
            echo 'Build Aborted, Notifying to slack..'
            sendSlackMessage('aborted', env.COMMIT_MESSAGE, env.SHORT_SHA, env.FULL_SHA)
        }
    }
}
