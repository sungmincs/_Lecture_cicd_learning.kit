# Apply multi-environment GitLab pipeline
## GitLab CI 멀티 환경 배포 파이프라인 복사
cd ~/workspace/worklog-backend-gitlab
cp ~/_Lecture_cicd_learning.kit/ch9/9.8/1.multi-env-pipeline.yml .gitlab-ci.yml
git add .
git commit -m "cicd: add multi-environment GitLab pipeline"
git push origin main

# Test MR-based deployment
## feature 브랜치 생성 후 MR을 통한 배포 테스트
git checkout -b feature/test-mr-deploy
echo "# test" >> README.md
git add .
git commit -m "test: MR deployment"
git push origin feature/test-mr-deploy
### GitLab UI에서 Merge Request 생성

# Test tag-based deployment
## 태그 생성으로 프로덕션 배포 테스트
git checkout main
git tag v1.0.0
git push origin v1.0.0

# Verify each deployment in the corresponding namespace
## dev namespace 확인
kubectl get pods -n dev

## staging namespace 확인
kubectl get pods -n staging

## prod namespace 확인
kubectl get pods -n prod
