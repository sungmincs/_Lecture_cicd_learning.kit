# 9.6 CD 강화 — 이미지 취약점 스캔 (Trivy)

# Trivy 로컬 설치 및 이미지 스캔 (이미지가 Docker Hub에 있어야 함)
# macOS: brew install trivy
# Linux: curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin

trivy image --severity CRITICAL,HIGH <dockerhub_username>/worklog-backend:latest

# 파이프라인 파일 복사 (사용하는 CI 도구 선택)
## GitHub Actions
cp ~/_Lecture_cicd_learning.kit/ch9/9.6/1.trivy-github.yaml .github/workflows/trivy.yaml
## Jenkins
cp ~/_Lecture_cicd_learning.kit/ch9/9.6/2.trivy-jenkins.groovy Jenkinsfile
## GitLab CI
cp ~/_Lecture_cicd_learning.kit/ch9/9.6/3.trivy-gitlab.yml .gitlab-ci.yml

# 커밋 및 푸시
git add .
git commit -m "cd: add trivy image vulnerability scan"
git push origin main

# 파이프라인 실행 확인
## GitHub: Actions 탭에서 scan job 로그 확인
## GitLab: CI/CD > Pipelines > trivy job 확인