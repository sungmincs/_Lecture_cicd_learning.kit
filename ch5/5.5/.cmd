# Simplify Jenkins pipeline using Plugins
## Ensure Docker Pipeline plugin is installed
### Dashboard -> Jenkins 관리 -> Plugins -> Available plugins -> Docker Pipeline

## Apply simplified pipeline using Docker Pipeline plugin
### Create new Jenkinsfile with plugin-based approach
cd ~/workspace/worklog-backend
cp ~/_Lecture_cicd_learning.kit/ch5/5.5/1.build-and-push-docker-image-plugin.groovy Jenkinsfile
git add .
git commit -m "cicd: simplify pipeline with Jenkins plugins"
git push origin main

## Trigger the pipeline in Jenkins
### Dashboard -> worklog-backend-pipeline -> Scan Multibranch Pipeline Now

## Check the result in Jenkins
### Compare the pipeline code with 5.4 version
