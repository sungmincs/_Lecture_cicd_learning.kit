# Apply full CI/CD workflow with Argo CD
## GitHub Actions + Argo CD 통합 파이프라인 복사
cd ~/workspace/worklog-backend
cp ~/_Lecture_cicd_learning.kit/ch9/9.5/1.full-cicd-workflow.yaml .github/workflows/full-cicd-workflow.yaml
git add .
git commit -m "cicd: full CI/CD workflow with Argo CD"
git push origin main

# Create Argo CD Applications for each environment
## dev, staging, prod 환경별 Argo CD Application 생성
kubectl apply -f ~/_Lecture_cicd_learning.kit/ch9/9.5/2.argocd-apps-multi-env.yaml

# Test full workflow
## 1. Push to develop → deploys to dev
## 2. Create PR to main → deploys preview to dev
## 3. Merge PR → deploys to staging
## 4. Create tag v1.0.0 → deploys to prod

# Verify
## Argo CD Application 목록 확인
argocd app list

## 각 환경 배포 상태 확인
kubectl get pods -n dev
kubectl get pods -n staging
kubectl get pods -n prod
