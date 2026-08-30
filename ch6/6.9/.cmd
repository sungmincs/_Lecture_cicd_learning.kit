# Update GitLab pipeline with Argo CD sync
cd ~/workspace/worklog-backend-gitlab
cp ~/_Lecture_cicd_learning.kit/ch6/6.8/1.build-and-argocd-sync.yml .gitlab-ci.yml
git add .
git commit -m "cicd: integrate Argo CD sync in pipeline"
git push origin main

## Verify in GitLab Pipelines and Argo CD UI
