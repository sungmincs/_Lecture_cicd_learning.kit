# Part A: Compare local and cloud environments
## Local: Vagrant + VirtualBox, single machine K8s
## Cloud: AWS EKS, managed K8s, auto-scaling

# Review current local setup
kubectl get nodes
kubectl cluster-info

# Key differences to note:
### Networking: NodePort/Ingress vs AWS ALB/NLB
### Storage: local PV vs EBS/EFS
### Security: local admin vs IAM roles
### Scaling: manual vs HPA + Cluster Autoscaler

# Part B: Install and configure AWS CLI

# Install AWS CLI
## Linux
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

## Verify
aws --version

# Configure AWS credentials
aws configure
### AWS Access Key ID: <aws_access_key_id>
### AWS Secret Access Key: <aws_secret_access_key>
### Default region name: ap-northeast-2
### Default output format: json

# Verify AWS access
aws sts get-caller-identity

# Install eksctl (optional but helpful)
## Linux
curl --silent --location "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
mv /tmp/eksctl /usr/local/bin

## Verify
eksctl version
