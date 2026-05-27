# GUARDRAIL: A.001 AI 시대에 변화하는 CI/CD

## 범위 (Scope)
### 이 단계에서 다루는 것
- AI가 코드를 작성하는 시대, CI의 역할 변화 체험
- AI 생성 코드의 특성 이해 (동작하지만 테스트/보안 검증 부재)
- 강화된 CI 게이트 구성 (lint, security scan, test coverage)
- 환경별 CD 자동화 수준 차등 적용 (dev/staging/prod)
- "AI 속도 + 사람 수준의 안전성" 균형 설계

### 이 단계에서 다루지 않는 것
- Claude Code 설치 및 기본 사용법 (ch2에서 다룸)
- CI/CD 파이프라인 기본 구성 (ch4~ch5에서 다룸)
- Argo CD 기본 설정 (ch6에서 다룸)
- 멀티 환경 배포 기초 (ch8에서 다룸)

## 사전 조건 (Prerequisites)
- ch5 완료 (CI 파이프라인 기본 구성)
- ch6 완료 (Argo CD 배포)
- ch7 완료 (마이크로서비스 배포 — Worklog App 전체 스택)
- ch8 완료 (멀티환경 배포 패턴 — dev/staging/prod namespace)
- Claude Code 설치 완료 (ch2에서 구성)

## 순서 (Sequence)

### Part 1: AI 코드 생성과 기존 CI의 한계

#### Step 1: Claude Code로 새 기능 추가
- Claude Code에 "Worklog Backend에 제목으로 검색하는 GET /search API를 추가해줘" 요청
- 기대 결과: 코드가 빠르게 생성됨

#### Step 2: 생성된 코드 점검
- 테스트 코드 존재 여부, 입력값 검증, 보안 취약점 확인
- 기대 결과: 동작은 하지만 검증이 부족한 코드임을 인식

#### Step 3: 기존 CI로 push
- `git push origin main`
- 기대 결과: 기존 CI는 빌드만 하므로 검증 없이 통과, 배포까지 도달

### Part 2: 강화된 CI 게이트 구성

#### Step 4: lint 단계 추가
- Python linter (ruff) 설정 및 파이프라인에 lint job 추가
- 기대 결과: 코드 스타일 위반 시 파이프라인 실패

#### Step 5: Security scan 단계 추가
- pip-audit (의존성 취약점), gitleaks (시크릿 노출 탐지) 추가
- 기대 결과: 보안 이슈 발견 시 파이프라인 실패

#### Step 6: 테스트 커버리지 임계값 설정
- pytest + coverage, 80% 미만이면 실패
- 기대 결과: 테스트 없는 AI 코드가 블록됨

#### Step 7: AI에게 수정 요청
- Claude Code에 "CI 검증을 통과하도록 테스트 추가하고 lint 에러 수정해줘" 요청
- 기대 결과: AI가 수정 → CI 통과 (AI 생성 → CI 블록 → AI 수정 사이클 체험)

### Part 3: 환경별 CD 자동화 수준 설계

#### Step 8: 환경별 정책 설정
- dev: Argo CD auto-sync (완전 자동)
- staging: CI 통과 후 자동 배포
- prod: CI 통과 + 사람 승인 필수
- 기대 결과: 3개 환경의 자동화 수준이 다르게 설정됨

#### Step 9: 전체 흐름 테스트
- Claude Code로 코드 변경 → push → CI 검증 → dev 자동 배포 → staging 자동 배포 → prod 승인 대기
- 기대 결과: end-to-end 흐름 확인

#### Step 10: 회고
- AI 시대에 사람의 역할: "코드 작성"에서 "배포 판단"으로 이동
- 어디까지 자동화하고 어디서 사람이 판단할 것인가

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| AI 코드 생성 | Claude Code 출력 확인 | 검색 API 코드 생성 완료 |
| 기존 CI | CI 대시보드 | 검증 없이 빌드 성공 |
| 강화된 CI (블록) | CI 대시보드 | lint/security/coverage 실패 |
| AI 수정 후 | CI 재실행 | 모든 게이트 통과 |
| dev 배포 | `kubectl get pods -n dev` | 자동 배포 확인 |
| staging 배포 | `kubectl get pods -n staging` | 자동 배포 확인 |
| prod 블록 | CI/CD UI | 승인 대기 상태 |
| prod 승인 | 수동 승인 후 확인 | prod 배포 완료 |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| 없음 | ch8, ch9 환경을 그대로 사용 | - |

## 주의사항 (Cautions)
- ⛔ prod 환경에 자동 배포를 설정하지 말 것 — 반드시 승인 게이트 유지
- ⛔ 검증 도구 설정에 지나치게 시간을 쓰지 말 것 — 핵심은 "게이트 개념"
- ✅ AI 생성 → CI 블록 → AI 수정 → CI 통과 사이클이 핵심 체험
- ✅ "AI가 빨라질수록, 검증과 판단 지점을 명확히 설계해야 한다"가 메시지
