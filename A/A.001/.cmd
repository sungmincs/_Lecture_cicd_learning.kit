# Part 1: AI 코드 생성과 기존 CI의 한계

# AI로 새 기능 추가
## Claude Code에 요청: "Worklog Backend에 제목으로 검색하는 GET /search API를 추가해줘"

# 생성된 코드 점검
## 테스트 코드 존재 여부 확인
ls tests/
## 입력값 검증 확인
grep -r "validate\|sanitize" src/

# 기존 CI로 push (검증 없이 통과되는지 확인)
cd ~/workspace/worklog-backend
git add .
git commit -m "feat: add search API"
git push origin main
### CI 대시보드에서 검증 없이 빌드 성공 확인

# Part 2: 강화된 CI 게이트 구성

# Lint 단계 추가
pip install ruff
ruff check src/

# Security scan 단계 추가
pip install pip-audit
pip-audit
### gitleaks: https://github.com/gitleaks/gitleaks
gitleaks detect --source .

# 테스트 커버리지 임계값
pip install pytest-cov
pytest --cov=src --cov-fail-under=80

# 강화된 CI 파이프라인 적용
## GitHub
cp ~/_Lecture_cicd_learning.kit/A/A.001/enhanced-ci.yaml .github/workflows/ci.yaml
## Jenkins
cp ~/_Lecture_cicd_learning.kit/A/A.001/enhanced-ci.groovy Jenkinsfile
## GitLab
cp ~/_Lecture_cicd_learning.kit/A/A.001/enhanced-ci.yml .gitlab-ci.yml

git add .
git commit -m "ci: add lint, security scan, and coverage gates"
git push origin main
### CI 대시보드에서 파이프라인 실패 확인 (기존 AI 코드가 블록됨)

# AI에게 수정 요청
## Claude Code에 요청: "CI 검증을 통과하도록 테스트 추가하고 lint 에러 수정해줘"

git add .
git commit -m "fix: add tests and fix lint errors for CI gates"
git push origin main
### CI 대시보드에서 모든 게이트 통과 확인

# Part 3: 환경별 CD 자동화 수준 설계

# dev: 완전 자동 배포
kubectl patch application worklog-dev -n argocd --type merge -p '{"spec":{"syncPolicy":{"automated":{"prune":true,"selfHeal":true}}}}'

# staging: CI 통과 후 자동 배포
kubectl patch application worklog-staging -n argocd --type merge -p '{"spec":{"syncPolicy":{"automated":{"prune":true,"selfHeal":true}}}}'

# prod: 사람 승인 필수 (auto-sync 비활성화)
kubectl patch application worklog-prod -n argocd --type merge -p '{"spec":{"syncPolicy":null}}'

# 전체 흐름 테스트
## Claude Code로 변경: "Worklog Backend에 /health 엔드포인트 추가해줘"
cd ~/workspace/worklog-backend
git add .
git commit -m "feat: add health check endpoint"
git push origin main

# 검증
kubectl get pods -n dev
kubectl get pods -n staging
### prod: 승인 대기 상태 확인 후 수동 승인
kubectl get pods -n prod
