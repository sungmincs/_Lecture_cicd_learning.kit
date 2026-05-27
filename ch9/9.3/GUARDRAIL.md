# GUARDRAIL: 9.3 CI 강화 — Lint (ruff)

## 범위 (Scope)
### 이 단계에서 다루는 것
- Python linter ruff를 사용한 코드 스타일 검사 자동화
- 기존 파이프라인에 lint job을 추가하는 패턴 학습
- GitHub Actions / Jenkins / GitLab CI 각각에 lint 단계 추가
- ruff 설정 파일(ruff.toml)로 검사 규칙 제어

### 이 단계에서 다루지 않는 것
- 보안 취약점 스캔 (9.4에서 다룸)
- 테스트 커버리지 임계값 설정 (9.5에서 다룸)
- ruff fix(자동 수정) — 파이프라인에서는 탐지만 수행

## 사전 조건 (Prerequisites)
- ch8 완료 (멀티환경 파이프라인 구성 — GitHub/Jenkins/GitLab 중 하나 이상)
- dev/staging/prod namespace 존재
- 학습자 fork 저장소에 기존 파이프라인 파일 존재
- worklog-backend 소스 코드에 `src/worklog/` 디렉토리 존재

## 순서 (Sequence)

### Step 1: ruff 설정 파일 복사 [학습자 직접]
- 명령어: `cp ~/_Lecture_cicd_learning.kit/ch9/9.3/ruff.toml ruff.toml`
- 기대 결과: 프로젝트 루트에 ruff.toml 생성

### Step 2: ruff 로컬 실행으로 이슈 확인 [학습자 직접]
- 명령어:
  ```
  uv sync --extra dev
  uv run ruff check src/
  ```
- 기대 결과: 린트 위반 항목 목록 출력 (또는 "All checks passed!")

### Step 3: 파이프라인 파일 복사 [학습자 직접]
사용하는 CI 도구에 맞게 복사:
- GitHub Actions: `cp ~/_Lecture_cicd_learning.kit/ch9/9.3/1.lint-github.yaml .github/workflows/lint.yaml`
- Jenkins: `cp ~/_Lecture_cicd_learning.kit/ch9/9.3/2.lint-jenkins.groovy Jenkinsfile` (기존 파일에 stage 추가 방식 권장)
- GitLab CI: `cp ~/_Lecture_cicd_learning.kit/ch9/9.3/3.lint-gitlab.yml .gitlab-ci.yml`

> **누적 구조 안내**: 9.3의 lint 파이프라인은 개념 학습용 독립 파일입니다.
> 9.5에서 lint + security + coverage를 하나로 합친 통합 파이프라인으로 교체됩니다.

### Step 4: 플레이스홀더 수정 [AI 프롬프트]
- Jenkins 파일의 `<github_username>` 수정
- AI 프롬프트 예시: "Jenkinsfile의 <github_username>을 내 GitHub 계정명으로 바꿔줘"

### Step 5: 커밋 및 푸시 [학습자 직접]
- 명령어: `git add . && git commit -m "ci: add lint gate with ruff" && git push origin main`
- 기대 결과: CI 파이프라인이 자동 트리거됨

### Step 6: 파이프라인 실행 결과 확인 [학습자 직접]
- GitHub: Actions 탭 → lint job 결과 확인
- Jenkins: 파이프라인 콘솔 로그 → Lint stage 확인
- GitLab: CI/CD → Pipelines → lint job 확인
- 기대 결과: lint job이 성공 또는 실패 (위반 항목이 있으면 실패)

### Step 7: lint 오류가 있는 경우 수정 [AI 프롬프트]
- AI 프롬프트 예시: "ruff check 결과에서 나온 오류들을 수정해줘"
- 수정 후 재푸시 → 파이프라인 재실행 → lint 통과 확인

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| ruff.toml 생성 | `ls ruff.toml` | 파일 존재 |
| 로컬 lint | `uv run ruff check src/` | 통과 또는 위반 목록 |
| 파이프라인 트리거 | CI 대시보드 확인 | lint job 실행 |
| lint 통과 | CI 대시보드 확인 | lint job 성공 |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| `<github_username>` | GitHub 사용자 이름 (Jenkins용) | ❌ 반드시 확인 필요 |

## 주의사항 (Cautions)
- ⛔ lint 실패 시 파이프라인 전체가 중단된다 — 처음에는 위반 항목이 많을 수 있으므로 ruff.toml로 ignore 범위를 조정하면서 점진적으로 도입한다
- ⛔ E501 (라인 길이 초과)은 기본 ignore 처리 — 너무 많은 위반이 발생하면 학습 흐름이 끊길 수 있음
- ✅ lint는 test보다 앞에 배치하는 것이 좋다 — 빠르게 실패해서 빠른 피드백 제공
- ✅ `uv run ruff check src/` 로컬에서 먼저 통과시킨 후 push하는 습관을 들인다
