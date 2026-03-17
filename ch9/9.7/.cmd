# Apply full CI/CD Jenkins pipeline with Argo CD
## Jenkins + Argo CD 통합 파이프라인 복사
cd ~/workspace/worklog-backend
cp ~/_Lecture_cicd_learning.kit/ch9/9.7/1.full-cicd-workflow.groovy Jenkinsfile
git add .
git commit -m "cicd: full CI/CD Jenkins workflow with Argo CD"
git push origin main

# Trigger pipeline in Jenkins
### Dashboard -> Scan Multibranch Pipeline Now

# Verify
## Argo CD Application 목록 확인
argocd app list

## 각 환경 배포 상태 확인
kubectl get pods -n dev
kubectl get pods -n staging
kubectl get pods -n prod
