# Update Jenkins pipeline with Argo CD sync
cp ~/_Lecture_cicd_learning.kit/ch6/6.7/1.build-and-argocd-sync.groovy Jenkinsfile
cd ~/workspace/worklog-backend
git add .
git commit -m "cicd: integrate Argo CD sync in Jenkins pipeline"
git push origin main

## Trigger pipeline in Jenkins and verify in Argo CD UI
