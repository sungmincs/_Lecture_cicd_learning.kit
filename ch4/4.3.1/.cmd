# Create ssh keypair for the Github repository interaction
## Create key pair in k8s controller node,
ssh-keygen -t ed25519 -C "your_email@example.com"
### > Enter a file in which to save the key (/home/YOU/.ssh/id_ALGORITHM):[Press enter]
### > Enter passphrase (empty for no passphrase): [Type a passphrase]
### > Enter same passphrase again: [Type passphrase again]
## Copy your ssh pubkey and add it to your github settings
### github.com -> settings -> SSH and GPG key

# Create Github Actions file
## create workflows directory and create action files
mkdir -p ~/workspace/worklog-frontend/.github/workflows/
## Create a new action file, "hello-actions.yaml" in "~/workspace/worklog-frontend/.github/workflows/" and type the following
### ^ this should be the same as `cp 1.hello-actions-hello.yaml ~/workspace/worklog-frontend/.github/workflows/`
```
# 2.hello-actions-hello.yaml
name: My First Pipeline

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Say Hello Github Actions
        run: echo "Hello Github Actions!"
```

## Check-in the git file and push to the registry
cd ~/workflows/workflog-frontend
git add .
git commit -m "my first actions pipeline"
git push origin main

## Go to Github actions UI and see the result
https://github.com/<github_username>/worklog-frontend_v1/actions/new

## Add more steps with actions details via Github Context https://docs.github.com/en/actions/learn-github-actions/contexts
## and Github Variables https://docs.github.com/en/actions/learn-github-actions/variables
```
# 3.hello-actions-final.yaml
name: My First Pipeline

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Say Hello Github Actions
        run: echo "Hello Github Actions!"

      - run: echo "🎉 The job was automatically triggered by a ${{ github.event_name }} event."
      - run: echo "🐧 This job is now running on a ${{ runner.os }} server hosted by GitHub!"
      - run: echo "🔎 The name of your branch is ${{ github.ref }} and your repository is ${{ github.repository }}."
      - name: Check out repository code
        uses: actions/checkout@v4
      - run: echo "💡 The ${{ github.repository }} repository has been cloned to the runner."
      - run: echo "🖥️ The workflow is now ready to test your code on the runner."
      - name: List files in the repository
        run: |
          echo "files in the workspace root"
          ls ${{ github.workspace }}
          echo "workspace structure"
          tree ${{ github.workspace }}
      - run: echo "🍏 This job's status is ${{ job.status }}."
```
## Check-in the git file and push to the registry
cd ~/workflows/workflog-frontend
git add .
git commit -m "add more steps for the details"
git push origin main

## Go to Github actions UI and see the result
https://github.com/<github_username>/worklog-frontend_v1/actions/new
