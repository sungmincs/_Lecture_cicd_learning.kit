# Update GitHub Actions pipeline with Argo CD sync
## Replace kubectl deploy step with Argo CD sync
cp ~/_Lecture_cicd_learning.kit/ch6/6.6/1.build-and-argocd-sync.yaml ~/workspace/worklog-backend/.github/workflows/build-and-argocd-sync.yaml
cd ~/workspace/worklog-backend
git add .
git commit -m "cicd: integrate Argo CD sync in pipeline"
git push origin main

## Verify in GitHub Actions and Argo CD UI
