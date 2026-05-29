pipeline {
    agent any
    environment {
        DOCKER_REPOSITORY = '<dockerhub_username>/worklog-backend'
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        GITHUB_CREDENTIALS = credentials('github-token')
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        ARGOCD_ADMIN_PASSWORD = credentials('argocd-admin-password')
        AWS_REGION = 'ap-northeast-2'
        EKS_CLUSTER_NAME = 'cicd-learning-eks'
        ARGOCD_APP_NAME = 'worklog-backend'
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
        stage('Test') {
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
        stage('Build') {
            steps {
                sh """
                    docker run --privileged --rm tonistiigi/binfmt --install all 2>/dev/null || true
                    docker buildx rm backend-builder 2>/dev/null || true
                    docker buildx create --name backend-builder --driver docker-container --use
                    echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login --username ${DOCKERHUB_CREDENTIALS_USR} --password-stdin
                    docker buildx build --platform linux/amd64 \\
                        -t ${DOCKER_REPOSITORY}:${SHORT_SHA} \\
                        --push .
                    echo "build successful: ${SHORT_SHA}"
                """
            }
        }
        stage('Configure AWS') {
            steps {
                sh """
                    aws eks update-kubeconfig --region ${AWS_REGION} --name ${EKS_CLUSTER_NAME}
                """
            }
        }
        stage('Update Manifest') {
            steps {
                script {
                    def sha = env.SHORT_SHA
                    def branch = env.BRANCH_NAME
                    sh """
                        git rebase --abort 2>/dev/null || true
                        sed -i "s|image: .*worklog-backend:.*|image: ${DOCKER_REPOSITORY}:${sha}|" deploy_manifest/worklog-backend.yaml
                        sed -i "s|value: .*# IMAGE_TAG|value: ${sha} # IMAGE_TAG|" deploy_manifest/worklog-backend.yaml
                        git config user.name "jenkins"
                        git config user.email "jenkins@myk8s.local"
                        git remote set-url origin "https://\$GITHUB_CREDENTIALS_USR:\$GITHUB_CREDENTIALS_PSW@github.com/<github_username>/worklog-backend.git"
                        git add deploy_manifest/
                        git diff --staged --quiet || git commit -m "deploy: update image tag to ${sha}"
                        git pull --rebase origin ${branch} || git rebase --abort
                        git push origin HEAD:${branch}
                    """
                }
            }
        }
        stage('Sync Argo CD') {
            steps {
                sh """
                    ARGOCD_SERVER=\$(kubectl get svc argocd-server -n argocd -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
                    argocd login \${ARGOCD_SERVER} \\
                        --username admin \\
                        --password ${ARGOCD_ADMIN_PASSWORD} \\
                        --insecure
                    argocd app sync ${ARGOCD_APP_NAME}
                    argocd app wait ${ARGOCD_APP_NAME} --health --timeout 120
                    echo "Argo CD sync completed for ${ARGOCD_APP_NAME}"
                """
            }
        }
    }
    post {
        success { echo "EKS + Argo CD pipeline completed for ${env.SHORT_SHA}" }
        failure { echo "EKS + Argo CD pipeline failed for ${env.SHORT_SHA}" }
    }
}
