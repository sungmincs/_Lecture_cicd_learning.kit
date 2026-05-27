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
        GITHUB_CREDENTIALS = credentials('github-token')
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        ARGOCD_ADMIN_PASSWORD = credentials('argocd-admin-password')
        AWS_REGION = 'ap-northeast-2'
        EKS_CLUSTER_NAME = 'cicd-learning-eks'
        ARGOCD_APP_NAME = 'worklog-backend'
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
        stage('Update Manifest') {
            steps {
                echo "Updating deploy manifest with new image tag ${env.SHORT_SHA}"
                sh """
                    cd deploy_manifest
                    sed -i "s|image: .*worklog-backend:.*|image: ${DOCKER_REPOSITORY}:${env.SHORT_SHA}|" worklog-backend.yaml
                    sed -i "s|value: .*# IMAGE_TAG|value: ${env.SHORT_SHA} # IMAGE_TAG|" worklog-backend.yaml
                    git config user.name "jenkins"
                    git config user.email "jenkins@myk8s.local"
                    git remote set-url origin "https://\$GITHUB_CREDENTIALS_USR:\$GITHUB_CREDENTIALS_PSW@github.com/<github_username>/worklog-backend.git"
                    git add .
                    git diff --staged --quiet || git commit -m "deploy: update image tag to ${env.SHORT_SHA}"
                    git pull --rebase origin ${env.BRANCH_NAME} || git rebase --abort
                    git push origin HEAD:${env.BRANCH_NAME}
                """
            }
        }
        stage('Sync Argo CD') {
            steps {
                echo "Syncing Argo CD application ${ARGOCD_APP_NAME}"
                sh """
                    ARGOCD_SERVER=\$(kubectl get svc argocd-server -n argocd -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
                    argocd login \${ARGOCD_SERVER} \\
                        --username admin \\
                        --password ${ARGOCD_ADMIN_PASSWORD} \\
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
