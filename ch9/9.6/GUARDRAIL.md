# GUARDRAIL: 9.6 CD 강화 — 이미지 취약점 스캔 (Trivy)

## 범위 (Scope)
### 이 단계에서 다루는 것
- Trivy로 빌드된 Docker 이미지의 OS/패키지 취약점 탐지
- CRITICAL, HIGH 심각도의 취약점 발견 시 파이프라인 실패
- 빌드 후 push 전(또는 직후) 스캔 단계를 CD 파이프라인에 삽입
- GitHub Actions / Jenkins / GitLab CI 각각에 trivy 스캔 단계 추가

### 이 단계에서 다루지 않는 것
- pip-audit 의존성 취약점 스캔 (9.4에서 다룸)
- prod 수동 승인 게이트 (9.7에서 다룸)
- Trivy를 사용한 파일시스템/코드 스캔
- 취약점 수정 방법 — 탐지와 인식이 목표

## 사전 조건 (Prerequisites)
- ch8 완료 (멀티환경 파이프라인 구성 — GitHub/Jenkins/GitLab 중 하나 이상)
- dev/staging/prod namespace 존재
- 학습자 fork 저장소에 기존 파이프라인 파일 존재
- 9.3, 9.4, 9.5 완료 (lint, security scan, coverage 단계 추가)
- Docker Hub에 학습자 이미지가 push된 이력 존재

## 순서 (Sequence)

### Step 1: 파이프라인 파일 복사 [학습자 직접]
사용하는 CI 도구에 맞게 복사:
- GitHub Actions: `cp ~/_Lecture_cicd_learning.kit/ch9/9.6/1.trivy-github.yaml .github/workflows/trivy.yaml`
- Jenkins: `cp ~/_Lecture_cicd_learning.kit/ch9/9.6/2.trivy-jenkins.groovy Jenkinsfile`
- GitLab CI: `cp ~/_Lecture_cicd_learning.kit/ch9/9.6/3.trivy-gitlab.yml .gitlab-ci.yml`

> **최종 누적 파이프라인**: 이 파일에는 lint → security → test → build → trivy scan → deploy 전체 흐름이 하나로 통합되어 있습니다.
> 9.5에서 만든 `coverage.yaml`을 삭제하고 이 파일로 대체하세요.
> ```bash
> # GitHub Actions 기준
> rm .github/workflows/coverage.yaml
> ```

### Step 2: 플레이스홀더 수정 [AI 프롬프트]
- `<dockerhub_username>` 수정
- Jenkins 파일의 `<github_username>` 수정
- AI 프롬프트 예시: "파이프라인의 <dockerhub_username>과 <github_username>을 내 계정명으로 바꿔줘"

### Step 3: 커밋 및 푸시 [학습자 직접]
- 명령어: `git add . && git commit -m "cd: add trivy image vulnerability scan" && git push origin main`
- 기대 결과: CI 파이프라인이 자동 트리거됨

### Step 4: 파이프라인 실행 결과 확인 [학습자 직접]
- trivy 스캔 job 로그에서 취약점 목록 확인
- CRITICAL/HIGH 취약점이 있으면 파이프라인 실패 → 탐지 결과를 기록
- 기대 결과: 스캔 결과 테이블 형식으로 출력, 취약점 수 확인

### Step 5: 취약점 탐지 결과 분석 [학습자 직접]
- 취약한 패키지, CVE 번호, 심각도 확인
- 베이스 이미지 변경으로 취약점을 줄일 수 있는지 탐색
- 기대 결과: 이미지 취약점의 존재 인식 및 대응 방향 이해

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| 파이프라인 트리거 | CI 대시보드 확인 | trivy job 실행 |
| 빌드 완료 | build job 로그 | 이미지 빌드 및 push 성공 |
| trivy 스캔 | scan job 로그 | 취약점 테이블 출력 |
| 취약점 없음 | CI 상태 | 파이프라인 성공 |
| 취약점 있음 | CI 상태 | 파이프라인 실패 (exit-code: 1) |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| `<dockerhub_username>` | Docker Hub 사용자 이름 | ❌ 반드시 확인 필요 |
| `<github_username>` | GitHub 사용자 이름 (Jenkins용) | ❌ 반드시 확인 필요 |

## 주의사항 (Cautions)
- ⛔ Trivy 스캔은 빌드 후 이미지가 push된 이후에 실행된다 — 스캔 실패 시 이미 push된 이미지는 삭제하거나 태그로 관리한다
- ⛔ CRITICAL/HIGH 취약점이 많은 베이스 이미지(예: ubuntu)를 사용하면 파이프라인이 자주 실패할 수 있다 — slim, distroless 이미지 사용을 검토
- ✅ 학습 단계에서는 `exit-code: '1'` 을 `exit-code: '0'`으로 바꿔 취약점이 있어도 파이프라인이 통과하게 하여 결과만 확인할 수도 있다
- ✅ Trivy 결과는 테이블 형식으로 출력된다 — CVE ID, 패키지명, 심각도를 기록해두는 습관을 들인다
