# Part A: EKS 직접 배포 파이프라인

# Configure GitLab CI/CD Variables for AWS
## Settings -> CI/CD -> Variables
### AWS_ACCESS_KEY_ID (Masked)
### AWS_SECRET_ACCESS_KEY (Masked)
### AWS_REGION: ap-northeast-2
### EKS_CLUSTER_NAME: cicd-learning-eks

# Apply EKS deployment pipeline
cp ~/_Lecture_cicd_learning.kit/ch10/10.7/1.eks-deploy-pipeline.yml ~/workspace/worklog-backend-gitlab/.gitlab-ci.yml
cd ~/workspace/worklog-backend-gitlab
git add .
git commit -m "cicd: deploy to EKS via GitLab"
git push origin main

# Verify deployment
## Check GitLab CI/CD -> Pipelines
kubectl get pods
kubectl get svc

# Part B: Argo CD 연동 파이프라인

# Configure GitLab CI/CD Variables for Argo CD
## Settings -> CI/CD -> Variables
### ARGOCD_SERVER (Masked)
### ARGOCD_PASSWORD (Masked)

# Apply Argo CD pipeline for GitLab on EKS
cd ~/workspace/worklog-backend-gitlab
cp ~/_Lecture_cicd_learning.kit/ch10/10.7/2.eks-argocd-pipeline.yml .gitlab-ci.yml
git add .
git commit -m "cicd: EKS + Argo CD GitLab pipeline"
git push origin main

# Verify
## Check GitLab Pipelines
## Check Argo CD UI
argocd app list
kubectl get pods
