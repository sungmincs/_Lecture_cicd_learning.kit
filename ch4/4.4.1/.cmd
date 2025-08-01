# Install Jenkins
## add helm repo
helm repo add edu https://k8s-edu.github.io/Lkv1_main/helm-charts/v1.30/cicd/
## install helm script
./install_jenkins.sh

## update host setting
```
192.168.1.99 jenkins.myk8s.local
```
### now the Jenkins should be accessible from the host browser with admin/admin

# Setup git credential
## dashboard -> Jenkins 관리 -> Credentials -> System -> Global Credentials
### Kind: SSH Username with private key
### Scope: Global
### ID: cicd-k8s-git-private-key
### Private Key, Enter directly
### No passphrase
## dashboard -> Jenkins 관리 -> Security
### Git Host Key Verification Configuration -> Host Key Verification Strategy -> Accept first connection

# Install plugins
## Plugins: Github, Github Branch Source, Pipeline: Stage View
# Create a new pipeline
## dashboard -> 새로운 Item -> item name: worklog-backend-pipeline / Multibranch Pipeline
### Display Name: worklog-backend-pipeline
### Branch Soruces
### GitHub: https://github.com/slinfra/worklog-backend.git
### GitHub credentials (username/PAT)

# Git Clone Sample Repo
git clone https://github.com/slinfra/worklog-backend.git

