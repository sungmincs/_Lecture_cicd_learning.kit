# Simplify pipeline using Marketplace Actions
## Replace manual docker build/push with marketplace actions
### Use docker/login-action, docker/build-push-action
cp ~/_Lecture_cicd_learning.kit/ch5/5.3/1.build-pipeline-marketplace.yaml ~/workspace/worklog-backend/.github/workflows/build-pipeline.yaml
cd ~/workspace/worklog-backend
git add .
git commit -m "cicd: simplify build pipeline with marketplace actions"
git push origin main

## Check the result in Github Actions
### Compare the pipeline code with 5.2 version
