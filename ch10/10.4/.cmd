# Install Terraform
## Linux
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
apt update && apt install terraform -y

## Verify
terraform version

# Initialize a simple Terraform project
mkdir -p ~/terraform-test
cd ~/terraform-test

# Create a simple main.tf to test AWS connection
cat << 'EOF' > main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
EOF

# Terraform workflow
terraform init
terraform plan
terraform apply

# Cleanup test
rm -rf ~/terraform-test

# Navigate to EKS Terraform directory
cd ~/_Lecture_cicd_learning.kit/ch10/10.3/terraform-eks

# Review Terraform files
ls -la

# Initialize Terraform
terraform init

# Plan EKS cluster
terraform plan

# Apply (create EKS cluster)
### This will take 15-20 minutes
terraform apply -auto-approve

# Configure kubectl for EKS
aws eks update-kubeconfig --region ap-northeast-2 --name cicd-learning-eks

# Verify EKS cluster
kubectl get nodes
kubectl cluster-info

# Install ingress controller on EKS
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.10.0/deploy/static/provider/aws/deploy.yaml

# Verify ingress
kubectl get svc -n ingress-nginx

# When done with all exercises, destroy EKS cluster
### WARNING: This will delete ALL resources and incur no further charges
cd ~/_Lecture_cicd_learning.kit/ch10/10.3/terraform-eks
terraform destroy -auto-approve
