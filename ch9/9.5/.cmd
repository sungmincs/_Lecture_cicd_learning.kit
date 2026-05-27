# 9.5 CI 강화 — Test Coverage 임계값

# 현재 커버리지 로컬 확인
uv sync --extra dev
export TESTING=true
uv run coverage run --source ./src/worklog -m pytest --disable-warnings -v
uv run coverage report
uv run coverage report --fail-under=80

# 파이프라인 파일 복사 (사용하는 CI 도구 선택)
## GitHub Actions
cp ~/_Lecture_cicd_learning.kit/ch9/9.5/1.coverage-github.yaml .github/workflows/coverage.yaml
## Jenkins
cp ~/_Lecture_cicd_learning.kit/ch9/9.5/2.coverage-jenkins.groovy Jenkinsfile
## GitLab CI
cp ~/_Lecture_cicd_learning.kit/ch9/9.5/3.coverage-gitlab.yml .gitlab-ci.yml

# 커밋 및 푸시
git add .
git commit -m "ci: add test coverage gate (80%)"
git push origin main

# 파이프라인 실행 확인
## GitHub: Actions 탭에서 test job 로그 확인
## GitLab: CI/CD > Pipelines > test job 확인