# GUARDRAIL: 4.3 GitHub Actions 첫 파이프라인 (Hello World)

> **GitHub Actions 초기 구성 단계** — 이 도구가 처음으로 설정됩니다.

## 범위 (Scope)
### 이 단계에서 다루는 것
- GitHub Actions 워크플로우 디렉토리 생성
- 첫 번째 Hello World 워크플로우 작성 및 실행
- GitHub Context와 Variables를 활용한 상세 워크플로우 작성
- GitHub Actions UI에서 실행 결과 확인

### 이 단계에서 다루지 않는 것
- 빌드 파이프라인 구조 (4.4에서 다룸)
- 실제 Docker 빌드 (ch5에서 다룸)
- Jenkins, GitLab CI/CD

## 사전 조건 (Prerequisites)
- ch3 완료
- GitHub 계정 보유
- worklog-frontend_v1 리포지토리 fork 완료 (ch3/3.2에서 수행)

## 순서 (Sequence)

### Step 1: 워크플로우 디렉토리 생성
- 명령어:
  ```bash
  mkdir -p ~/workspace/worklog-frontend/.github/workflows/
  ```
- 기대 결과: .github/workflows/ 디렉토리 생성됨

### Step 2: Hello World 워크플로우 작성
- `~/workspace/worklog-frontend/.github/workflows/hello-actions.yaml` 파일 생성
- 참고 파일: `1.hello-actions_basic.yaml`
- 내용: push on main 트리거, ubuntu-latest runner, checkout + echo "Hello Github Actions!"
- 기대 결과: yaml 파일이 작성됨

### Step 3: Git Push
- 명령어:
  ```bash
  cd ~/workspace/worklog-frontend
  git add .
  git commit -m "my first actions pipeline"
  git push origin main
  ```
- 기대 결과: GitHub에 push됨

### Step 4: GitHub Actions UI에서 결과 확인
- https://github.com/<github_username>/worklog-frontend_v1/actions 에서 확인
- 기대 결과: 워크플로우가 실행되고 녹색 체크 표시

### Step 5: Context/Variables 활용 버전 작성
- `hello-actions.yaml`을 업데이트하여 GitHub Context와 Variables를 활용하는 상세 버전 작성
- 참고 파일: `2.hello-actions_variables.yaml`
- 활용하는 Context: `github.event_name`, `runner.os`, `github.ref`, `github.repository`, `github.workspace`, `job.status`
- 참고 문서:
  - GitHub Context: https://docs.github.com/en/actions/learn-github-actions/contexts
  - GitHub Variables: https://docs.github.com/en/actions/learn-github-actions/variables

### Step 6: 상세 버전 Push 및 결과 확인
- 명령어:
  ```bash
  git add .
  git commit -m "add more steps for the details"
  git push origin main
  ```
- GitHub Actions UI에서 결과 확인
- 기대 결과: 상세 정보가 출력되는 워크플로우 실행 성공

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| 기본 파이프라인 | GitHub Actions 탭 확인 | 녹색 체크 (성공) |
| 상세 파이프라인 | GitHub Actions 탭 > 실행 로그 확인 | Context 변수 값이 정상 출력 |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| `<github_username>` | 수강생의 GitHub 사용자명 | ❌ 반드시 수강생에게 확인 |

## 주의사항 (Cautions)
- ⛔ AI가 하지 말아야 할 것: 전체 yaml 파일 내용을 한 번에 제공하지 말 것 — 수강생이 직접 타이핑하는 것이 학습에 도움됨. 단계별로 안내할 것
- ⛔ AI가 하지 말아야 할 것: `<github_username>`을 임의로 채우지 말 것
- ⛔ AI가 하지 말아야 할 것: Step 2를 건너뛰고 바로 상세 버전(Step 5)으로 가지 말 것 — 기본 Hello World를 먼저 경험해야 함
- ✅ AI가 해도 되는 것: yaml 문법 오류에 대한 디버깅 지원
- ✅ AI가 해도 되는 것: GitHub Actions UI 탐색 방법 안내
- ✅ AI가 해도 되는 것: 각 GitHub Context 변수의 의미 설명
