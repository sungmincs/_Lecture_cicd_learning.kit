# Simplify GitLab pipeline using includes/extends
## Apply simplified pipeline with GitLab CI/CD extensions
cd ~/workspace/worklog-backend-gitlab
cp ~/_Lecture_cicd_learning.kit/ch5/5.7/1.build-deploy-pipeline-extension.yml .gitlab-ci.yml
git add .
git commit -m "cicd: simplify pipeline with GitLab extensions"
git push origin main

## Check the result in GitLab CI/CD -> Pipelines
### Compare the pipeline code with 5.6 version
