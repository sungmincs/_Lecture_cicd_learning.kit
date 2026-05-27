# Setup GitLab CI/CD variables
## Settings -> CI/CD -> Variables
### DOCKERHUB_USERNAME: <dockerhub_username>
### DOCKERHUB_TOKEN: <dockerhub_token>

# Apply build and deploy pipeline
cd ~/workspace/worklog-backend-gitlab
cp ~/_Lecture_cicd_learning.kit/ch5/5.6/1.build-pipeline.yml .gitlab-ci.yml
git add .
git commit -m "cicd: add build and push pipeline"
git push origin main

## Check the result in GitLab CI/CD -> Pipelines
