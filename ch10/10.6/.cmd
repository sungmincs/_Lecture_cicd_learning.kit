# ============================================================
# Part A: Jenkins EKS 직접 배포
# ============================================================

# Configure Jenkins credentials for AWS
## Dashboard -> Jenkins 관리 -> Credentials -> System -> Global credentials
### Add: aws-access-key-id (Secret text) - AWS Access Key ID
### Add: aws-secret-access-key (Secret text) - AWS Secret Access Key
### Add: eks-cluster-name (Secret text) - cicd-learning-eks

# Install AWS CLI and kubectl on Jenkins agent (if not already installed)
## Manage Jenkins -> Manage Plugins -> Install "AWS Steps" plugin

# Apply EKS deployment pipeline
cp ~/_Lecture_cicd_learning.kit/ch10/10.6/1.eks-deploy-pipeline.groovy ~/workspace/worklog-backend/Jenkinsfile
cd ~/workspace/worklog-backend
git add .
git commit -m "cicd: deploy to EKS via Jenkins"
git push origin main

# Trigger build in Jenkins
## Dashboard -> worklog-backend -> Build Now

# Verify deployment
kubectl get pods
kubectl get svc

# ============================================================
# Part B: Jenkins + Argo CD 연동 배포
# ============================================================

# Add Argo CD credentials to Jenkins
## Dashboard -> Jenkins 관리 -> Credentials -> System -> Global credentials
### Add: argocd-admin-password (Secret text) - Argo CD admin password

# Apply Argo CD pipeline for Jenkins
cp ~/_Lecture_cicd_learning.kit/ch10/10.6/2.eks-argocd-pipeline.groovy ~/workspace/worklog-backend/Jenkinsfile
cd ~/workspace/worklog-backend
git add .
git commit -m "cicd: EKS + Argo CD Jenkins pipeline"
git push origin main

# Trigger build in Jenkins
## Dashboard -> worklog-backend -> Build Now

# Verify
## Check Jenkins build console
## Check Argo CD UI for sync status
kubectl get pods
