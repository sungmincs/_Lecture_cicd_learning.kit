# Setup Docker Hub Credentials in Jenkins
## Dashboard -> Jenkins 관리 -> Credentials -> System -> Global Credentials
### Kind: Username with password
### ID: dockerhub-credentials
### Username: <dockerhub_username>
### Password: <dockerhub_token>

# Apply build and deploy pipeline
## Copy Jenkinsfile to the project
cd ~/workspace/worklog-backend
cp ~/_Lecture_cicd_learning.kit/ch5/5.4/1.build-and-push-docker-image.groovy Jenkinsfile
git add .
git commit -m "cicd: add build and push Jenkins pipeline"
git push origin main

## Trigger the pipeline in Jenkins
### Dashboard -> worklog-backend-pipeline -> Scan Multibranch Pipeline Now
