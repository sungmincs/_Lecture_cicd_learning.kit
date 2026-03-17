# Setup GitLab CI/CD Variables
## For both frontend and backend repos
### Settings -> CI/CD -> Variables
### DOCKERHUB_USERNAME, DOCKERHUB_TOKEN, KUBE_CONFIG

# Apply frontend pipeline
cd ~/workspace/worklog-frontend-gitlab
cp ~/_Lecture_cicd_learning.kit/ch8/8.5/1.frontend-build-deploy.yml .gitlab-ci.yml
git add .
git commit -m "cicd: add frontend GitLab pipeline"
git push origin main

# Apply backend pipeline
cd ~/workspace/worklog-backend-gitlab
cp ~/_Lecture_cicd_learning.kit/ch8/8.5/2.backend-build-deploy.yml .gitlab-ci.yml
git add .
git commit -m "cicd: add backend GitLab pipeline"
git push origin main

# Verify in GitLab Pipelines
