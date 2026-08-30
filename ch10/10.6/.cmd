# ============================================
# Part A: EKS 직접 배포 파이프라인
# ============================================

# Update GitHub Secrets for EKS
## Settings -> Secrets and variables -> Actions
### AWS_ACCESS_KEY_ID: AWS 액세스 키
### AWS_SECRET_ACCESS_KEY: AWS 시크릿 키
### AWS_REGION: ap-northeast-2
### EKS_CLUSTER_NAME: cicd-learning-eks

# Apply EKS deployment pipeline
cp ~/_Lecture_cicd_learning.kit/ch10/10.5/1.eks-deploy-pipeline.yaml ~/workspace/worklog-backend/.github/workflows/eks-deploy.yaml
cd ~/workspace/worklog-backend
git add .
git commit -m "cicd: deploy to EKS via GitHub Actions"
git push origin main

# Verify deployment
## Check GitHub Actions tab for workflow run
kubectl get pods
kubectl get svc

# ============================================
# Part B: Argo CD 연동 파이프라인
# ============================================

# Update GitHub Secrets for Argo CD
## Settings -> Secrets and variables -> Actions
### ARGOCD_ADMIN_PASSWORD: Argo CD 초기 비밀번호

# Apply Argo CD pipeline
cp ~/_Lecture_cicd_learning.kit/ch10/10.5/2.eks-argocd-pipeline.yaml ~/workspace/worklog-backend/.github/workflows/eks-argocd.yaml
cd ~/workspace/worklog-backend
git add .
git commit -m "cicd: EKS + Argo CD pipeline via GitHub Actions"
git push origin main

# Verify
## Check GitHub Actions tab for workflow run
## Check Argo CD UI (LoadBalancer URL) for sync status
kubectl get pods
