# Apply multi-environment Jenkins pipeline
## Jenkins 멀티 환경 배포 파이프라인 복사
cd ~/workspace/worklog-backend
cp ~/_Lecture_cicd_learning.kit/ch9/9.6/1.multi-env-pipeline.groovy Jenkinsfile
git add .
git commit -m "cicd: add multi-environment Jenkins pipeline"
git push origin main

# Configure Jenkins Multibranch Pipeline
## Jenkins Dashboard -> New Item -> Multibranch Pipeline
### Item name: worklog-backend-multi-env
## Branch Sources -> Add source -> Git
### Repository URL: https://github.com/<github_username>/worklog-backend.git
### Credentials: github-credentials
## Behaviours -> Add -> Discover branches (strategy: All branches)
## Behaviours -> Add -> Discover tags
## Save

# Trigger pipeline in Jenkins
### Dashboard -> worklog-backend-multi-env -> Scan Multibranch Pipeline Now

# Test branch-based deployment
## develop 브랜치 push 확인
git checkout develop
echo "# dev test" >> README.md
git add .
git commit -m "test: develop branch deployment"
git push origin develop
git checkout main

# Test tag-based deployment
## 프로덕션 배포용 태그 생성
git tag v1.0.0
git push origin v1.0.0

# Verify
kubectl get pods -n dev
kubectl get pods -n staging
kubectl get pods -n prod
