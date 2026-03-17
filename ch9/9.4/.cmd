# Apply multi-environment pipeline
## GitHub Actions 멀티 환경 배포 파이프라인 복사
cd ~/workspace/worklog-backend
cp ~/_Lecture_cicd_learning.kit/ch9/9.4/1.multi-env-pipeline.yaml .github/workflows/multi-env-pipeline.yaml
git add .
git commit -m "cicd: add multi-environment pipeline"
git push origin main

# Test PR-based deployment
## feature 브랜치 생성 후 PR을 통한 배포 테스트
git checkout -b feature/test-pr-deploy
echo "# test" >> README.md
git add .
git commit -m "test: PR deployment"
git push origin feature/test-pr-deploy
### GitHub UI에서 PR 생성

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
