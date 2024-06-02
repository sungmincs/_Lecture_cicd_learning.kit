
# Sign up Gitlab (Free signup menu is hidden)
## Sign in -> Register Now
### Sign up
### Fork from https://gitlab.com/sungmincs/worklog-backend, with the name `worklog-backend-gitlab`

# Create ssh keypair for the Gitlab repository interaction
## Create key pair in k8s controller node,
ssh-keygen -t ed25519 -C "your_email@example.com"
### > Enter a file in which to save the key (/home/YOU/.ssh/id_ALGORITHM):[Press enter]   # <- ssh config should change if you change this
### > Enter passphrase (empty for no passphrase): [Type a passphrase]
### > Enter same passphrase again: [Type passphrase again]
## Copy your ssh pubkey and add it to your gitlab settings
### gitlab.com -> edit profile -> SSH Keys -> Add New Key -> Paste the value of `~/.ssh/id_ed25519`


@REM ## Create a PAT
@REM ### Profile -> Access Tokens -> Add New Token
@REM ### Token Name: cp-k8s-git
@REM ### Expiration Date
@REM ### read_repository, write_repository

# Git Clone sample repo
git clone git@gitlab.com:<username>/worklog-backend-gitlab.git

# Applying CI/CD script
## 1.hello-gitlab.yml
### cd into project directory and copy the gitlab-ci file
cd worklog-backend-gitlab
cp ~/_Lecture_cicd_learning.kit/ch4/4.5.1/1.hello-gitlab.yml .gitlab-ci.yml
git diff .
git add .
git commit -m "add hello world .gitlab-ci.yml pipeline"
git push origin main
### check the user gitlab page, and show build->pipelines

## 2.hello-gitlab-variables.yml
cd worklog-backend-gitlab
cp ~/_Lecture_cicd_learning.kit/ch4/4.5.1/2.hello-gitlab-variables.yml .gitlab-ci.yml
git diff .
git add .
git commit -m "update .gitlab-ci.yml to learn variables"
