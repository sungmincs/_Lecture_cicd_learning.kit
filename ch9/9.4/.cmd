# 9.4 CI 강화 — Security Scan (pip-audit, gitleaks)

# pip-audit 로컬 실행
uv sync --extra dev
uv run pip-audit

# gitleaks 로컬 실행 (설치 필요: https://github.com/gitleaks/gitleaks)
gitleaks detect --source .

# 설정 파일 복사
cp ~/_Lecture_cicd_learning.kit/ch9/9.4/.gitleaks.toml .gitleaks.toml

# 파이프라인 파일 복사 (사용하는 CI 도구 선택)
## GitHub Actions
cp ~/_Lecture_cicd_learning.kit/ch9/9.4/1.security-github.yaml .github/workflows/security.yaml
## Jenkins
cp ~/_Lecture_cicd_learning.kit/ch9/9.4/2.security-jenkins.groovy Jenkinsfile
## GitLab CI
cp ~/_Lecture_cicd_learning.kit/ch9/9.4/3.security-gitlab.yml .gitlab-ci.yml

# 커밋 및 푸시
git add .
git commit -m "ci: add security scan (pip-audit, gitleaks)"
git push origin main

# 파이프라인 실행 확인
## GitHub: Actions 탭에서 security-scan job 확인
## GitLab: CI/CD > Pipelines > security-scan job 확인
