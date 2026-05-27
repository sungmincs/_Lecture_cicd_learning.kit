# Setup GitHub Secrets for full stack deployment
## Repository: worklog-frontend_v1
### Settings -> Secrets and variables -> Actions
### DOCKERHUB_USERNAME, DOCKERHUB_TOKEN, KUBE_CONFIG

## Repository: worklog-backend_v1
### Same secrets

# Apply frontend pipeline
cd ~/workspace/worklog-frontend
cp ~/_Lecture_cicd_learning.kit/ch8/8.3/1.frontend-build-deploy.yaml .github/workflows/build-deploy.yaml
git add .
git commit -m "cicd: add frontend build and deploy pipeline"
git push origin main

# Apply backend pipeline
cd ~/workspace/worklog-backend
cp ~/_Lecture_cicd_learning.kit/ch8/8.3/2.backend-build-deploy.yaml .github/workflows/build-deploy.yaml
git add .
git commit -m "cicd: add backend build and deploy pipeline"
git push origin main

# Verify
## Check GitHub Actions for both repos
## Access: http://worklog-frontend.myk8s.local
