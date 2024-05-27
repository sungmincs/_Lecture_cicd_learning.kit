# Install Jenkins
## install helm script
./install_jenkins.sh

## update host setting
```
192.168.1.11 jenkins.myk8s.local
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

# Create a new pipeline
## dashboard -> 새로운 Item -> item name: worklog-backend-pipeline / Multibranch Pipeline
### Display Name: worklog-backend-pipeline
### Branch Soruces
### Git: git@github.com:<username>/worklog-backend.git
### Credentials: git




