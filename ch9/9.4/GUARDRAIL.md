# GUARDRAIL: 9.4 CI 강화 — Security Scan (pip-audit, gitleaks)

## 범위 (Scope)
### 이 단계에서 다루는 것
- pip-audit로 Python 의존성 패키지의 알려진 취약점 탐지
- gitleaks로 저장소에 노출된 시크릿(비밀번호, 토큰, API 키 등) 탐지
- 기존 파이프라인에 security-scan job을 추가하는 패턴 학습
- .gitleaks.toml로 탐지 예외 범위 설정

### 이 단계에서 다루지 않는 것
- 이미지 취약점 스캔 (9.6에서 다룸)
- lint 설정 (9.3에서 다룸)
- 취약점 수정 방법 — 탐지와 인식이 목표
- SAST(정적 분석 보안 테스트) 전반

## 사전 조건 (Prerequisites)
- ch8 완료 (멀티환경 파이프라인 구성 — GitHub/Jenkins/GitLab 중 하나 이상)
- dev/staging/prod namespace 존재
- 학습자 fork 저장소에 기존 파이프라인 파일 존재
- 9.3 완료 (lint 단계 추가)

## 순서 (Sequence)

### Step 1: gitleaks 설정 파일 복사 [학습자 직접]
- 명령어: `cp ~/_Lecture_cicd_learning.kit/ch9/9.4/.gitleaks.toml .gitleaks.toml`
- 기대 결과: 프로젝트 루트에 .gitleaks.toml 생성

### Step 2: pip-audit 로컬 실행으로 이슈 확인 [학습자 직접]
- 명령어:
  ```
  uv sync --extra dev
  uv run pip-audit
  ```
- 기대 결과: 취약점 목록 출력 (또는 "No known vulnerabilities found")

### Step 3: 파이프라인 파일 복사 [학습자 직접]
사용하는 CI 도구에 맞게 복사:
- GitHub Actions: `cp ~/_Lecture_cicd_learning.kit/ch9/9.4/1.security-github.yaml .github/workflows/security.yaml`
- Jenkins: `cp ~/_Lecture_cicd_learning.kit/ch9/9.4/2.security-jenkins.groovy Jenkinsfile`
- GitLab CI: `cp ~/_Lecture_cicd_learning.kit/ch9/9.4/3.security-gitlab.yml .gitlab-ci.yml`

> **누적 구조 안내**: 9.4의 security 파이프라인은 개념 학습용 독립 파일입니다.
> 9.5에서 lint + security + coverage를 하나로 합친 통합 파이프라인으로 교체됩니다.

### Step 4: 플레이스홀더 수정 [AI 프롬프트]
- Jenkins 파일의 `<github_username>` 수정
- AI 프롬프트 예시: "Jenkinsfile의 <github_username>을 내 GitHub 계정명으로 바꿔줘"

### Step 5: 커밋 및 푸시 [학습자 직접]
- 명령어: `git add . && git commit -m "ci: add security scan (pip-audit, gitleaks)" && git push origin main`
- 기대 결과: CI 파이프라인이 자동 트리거됨

### Step 6: 파이프라인 실행 결과 확인 [학습자 직접]
- security-scan job 로그에서 pip-audit, gitleaks 결과 확인
- 기대 결과: 취약점이나 시크릿이 없으면 성공, 있으면 실패

### Step 7: 탐지 결과 분석 [학습자 직접]
- pip-audit 결과: 취약한 패키지 목록 확인, CVE 번호 기록
- gitleaks 결과: 탐지된 시크릿 경로 확인, 오탐(false positive)은 .gitleaks.toml allowlist에 추가
- 기대 결과: 보안 이슈의 존재 인식 및 대응 방향 이해

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| .gitleaks.toml 생성 | `ls .gitleaks.toml` | 파일 존재 |
| 로컬 pip-audit | `uv run pip-audit` | 취약점 목록 또는 "No known vulnerabilities" |
| 파이프라인 트리거 | CI 대시보드 확인 | security-scan job 실행 |
| pip-audit 통과 | CI 로그 확인 | 취약점 없음 또는 known 취약점 수 출력 |
| gitleaks 통과 | CI 로그 확인 | 시크릿 탐지 없음 |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| `<github_username>` | GitHub 사용자 이름 (Jenkins용) | ❌ 반드시 확인 필요 |

## 주의사항 (Cautions)
- ⛔ gitleaks가 .env 파일이나 테스트용 더미 시크릿을 탐지하면 파이프라인이 실패한다 — .gitleaks.toml의 allowlist로 예외 처리
- ⛔ pip-audit가 취약점을 발견하면 파이프라인이 실패한다 — 교육 목적에서는 발견 자체가 학습 목표이므로 당황하지 않아도 됨
- ✅ fetch-depth: 0 설정이 gitleaks가 전체 커밋 히스토리를 스캔하는 데 필요하다 (GitHub Actions)
- ✅ 탐지된 취약점은 즉시 수정보다 "인식하고 기록하는" 것이 이 단계의 목표
