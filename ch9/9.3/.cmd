# 9.3 CI 강화 — Lint (ruff)

# ruff 로컬 설치 및 실행
uv sync --extra dev
uv run ruff check src/

# ruff 자동 수정 (로컬에서만, 파이프라인은 check만)
uv run ruff check --fix src/

# ruff.toml 복사
cp ~/_Lecture_cicd_learning.kit/ch9/9.3/ruff.toml ruff.toml

# 파이프라인 파일 복사 (사용하는 CI 도구 선택)
## GitHub Actions
cp ~/_Lecture_cicd_learning.kit/ch9/9.3/1.lint-github.yaml .github/workflows/lint.yaml
## Jenkins (기존 Jenkinsfile에 stage 추가 방식 권장)
cp ~/_Lecture_cicd_learning.kit/ch9/9.3/2.lint-jenkins.groovy Jenkinsfile
## GitLab CI
cp ~/_Lecture_cicd_learning.kit/ch9/9.3/3.lint-gitlab.yml .gitlab-ci.yml

# 커밋 및 푸시
git add .
git commit -m "ci: add lint gate with ruff"
git push origin main

# 파이프라인 실행 확인
## GitHub: Actions 탭에서 lint job 확인
## GitLab: CI/CD > Pipelines > lint job 확인
