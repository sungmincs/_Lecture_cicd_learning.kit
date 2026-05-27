# Setup Jenkins Credentials
## Dashboard -> Jenkins 관리 -> Credentials
### dockerhub-credentials (Username with password)
### kube-config (Secret file)

# Apply frontend pipeline
cd ~/workspace/worklog-frontend
cp ~/_Lecture_cicd_learning.kit/ch8/8.4/1.frontend-build-deploy.groovy Jenkinsfile
git add .
git commit -m "cicd: add frontend Jenkins pipeline"
git push origin main

# Apply backend pipeline
cd ~/workspace/worklog-backend
cp ~/_Lecture_cicd_learning.kit/ch8/8.4/2.backend-build-deploy.groovy Jenkinsfile
git add .
git commit -m "cicd: add backend Jenkins pipeline"
git push origin main

# Trigger pipelines
### Dashboard -> Scan Multibranch Pipeline Now
