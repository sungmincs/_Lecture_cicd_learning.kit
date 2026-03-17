# Apply full CI/CD GitLab pipeline with Argo CD
## GitLab CI + Argo CD 통합 파이프라인 복사
cd ~/workspace/worklog-backend-gitlab
cp ~/_Lecture_cicd_learning.kit/ch9/9.9/1.full-cicd-workflow.yml .gitlab-ci.yml
git add .
git commit -m "cicd: full CI/CD workflow with Argo CD"
git push origin main

# Verify
## Argo CD Application 목록 확인
argocd app list

## 각 환경 배포 상태 확인
kubectl get pods -n dev
kubectl get pods -n staging
kubectl get pods -n prod
