# GUARDRAIL: 9.5 CI 강화 — Test Coverage 임계값

## 범위 (Scope)
### 이 단계에서 다루는 것
- pytest + coverage로 테스트 커버리지 측정 자동화
- 80% 미만이면 파이프라인을 실패시키는 임계값 게이트 설정
- 커버리지 미달 시 AI에게 테스트 추가 요청하는 사이클 체험
- GitHub Actions / Jenkins / GitLab CI 각각에 coverage 게이트 추가

### 이 단계에서 다루지 않는 것
- lint, security scan (9.3, 9.4에서 다룸)
- 이미지 취약점 스캔 (9.6에서 다룸)
- 커버리지 리포트 HTML 생성 및 아티팩트 저장
- 브랜치별 커버리지 임계값 차등 설정

## 사전 조건 (Prerequisites)
- ch8 완료 (멀티환경 파이프라인 구성 — GitHub/Jenkins/GitLab 중 하나 이상)
- dev/staging/prod namespace 존재
- 학습자 fork 저장소에 기존 파이프라인 파일 존재
- 9.3, 9.4 완료 (lint, security scan 단계 추가)

## 순서 (Sequence)

### Step 1: 현재 커버리지 로컬 확인 [학습자 직접]
- 명령어:
  ```
  uv sync --extra dev
  export TESTING=true
  uv run coverage run --source ./src/worklog -m pytest --disable-warnings -v
  uv run coverage report --fail-under=80
  ```
- 기대 결과: 현재 커버리지 % 출력, 80% 미만이면 오류 코드 반환

### Step 2: 파이프라인 파일 복사 [학습자 직접]
사용하는 CI 도구에 맞게 복사:
- GitHub Actions: `cp ~/_Lecture_cicd_learning.kit/ch9/9.5/1.coverage-github.yaml .github/workflows/coverage.yaml`
- Jenkins: `cp ~/_Lecture_cicd_learning.kit/ch9/9.5/2.coverage-jenkins.groovy Jenkinsfile`
- GitLab CI: `cp ~/_Lecture_cicd_learning.kit/ch9/9.5/3.coverage-gitlab.yml .gitlab-ci.yml`

> **통합 파이프라인 교체**: 이 파일에는 lint + security-scan + test(coverage)가 하나로 통합되어 있습니다.
> 9.3에서 만든 `lint.yaml`과 9.4에서 만든 `security.yaml`을 삭제하고 이 파일로 대체하세요.
> ```bash
> # GitHub Actions 기준
> rm .github/workflows/lint.yaml .github/workflows/security.yaml
> ```

### Step 3: 플레이스홀더 수정 [AI 프롬프트]
- Jenkins 파일의 `<github_username>` 수정
- AI 프롬프트 예시: "Jenkinsfile의 <github_username>을 내 GitHub 계정명으로 바꿔줘"

### Step 4: 커밋 및 푸시 [학습자 직접]
- 명령어: `git add . && git commit -m "ci: add test coverage gate (80%)" && git push origin main`
- 기대 결과: CI 파이프라인이 자동 트리거됨

### Step 5: 파이프라인 실행 결과 확인 [학습자 직접]
- test job 로그에서 커버리지 % 확인
- 80% 미만이면 파이프라인 실패 → 다음 단계로 진행
- 기대 결과: 커버리지 게이트 동작 확인

### Step 6: 커버리지 미달 시 — AI에게 테스트 추가 요청 [AI 프롬프트]
- AI 프롬프트 예시: "현재 커버리지가 XX%야. 80% 이상 달성하도록 테스트를 추가해줘"
- 수정 후 재푸시 → 파이프라인 재실행 → 커버리지 통과 확인
- 기대 결과: "AI 생성 → CI 블록 → AI 수정 → CI 통과" 사이클 체험

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| 로컬 커버리지 | `uv run coverage report --fail-under=80` | 현재 커버리지 % 출력 |
| 파이프라인 트리거 | CI 대시보드 확인 | test job 실행 |
| 커버리지 게이트 | CI 로그 확인 | 80% 미만 시 실패, 이상 시 성공 |
| AI 수정 후 | CI 재실행 | 커버리지 80% 이상 달성, 파이프라인 통과 |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| `<github_username>` | GitHub 사용자 이름 (Jenkins용) | ❌ 반드시 확인 필요 |

## 주의사항 (Cautions)
- ⛔ `--fail-under=80` 임계값은 학습 목적의 기준 — 실제 프로젝트에서는 팀 기준에 맞게 조정
- ⛔ 커버리지가 80% 미달이어도 당황하지 않는다 — 이 자체가 학습 체험의 일부
- ✅ `TESTING=true` 환경변수가 없으면 pytest 실행 시 실제 DB에 연결 시도할 수 있다 — 반드시 설정
- ✅ 임계값을 낮추어(예: 50%) 먼저 파이프라인이 통과함을 확인한 뒤, 점진적으로 올리는 방식도 유효
