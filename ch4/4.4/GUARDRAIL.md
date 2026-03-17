# GUARDRAIL: 4.4 GitHub Actions 빌드 파이프라인 구조 만들기

## 범위 (Scope)
### 이 단계에서 다루는 것
- GitHub Actions 파이프라인의 Job 의존성 (`needs`)
- 기본 3단계 파이프라인 (test → build → deploy)
- build 실패 시나리오 테스트
- Job 간 변수 전달
- 조건부 실행 및 알림

### 이 단계에서 다루지 않는 것
- 실제 Docker 빌드 (ch5에서 다룸)
- GitHub Marketplace Action 활용 (5.3에서 다룸)
- Jenkins, GitLab CI/CD

## 사전 조건 (Prerequisites)
- ch4/4.3 완료 (GitHub Actions 기본 파이프라인 실행 경험)

## 순서 (Sequence)

### Step 1: 기본 3단계 파이프라인 작성
- 참고 파일: `1.hello-pipeline.yaml`
- 내용: test → build → deploy 순서로 실행되는 3개의 Job (`needs` 키워드 사용)
- Push 후 Actions 탭에서 파이프라인 그래프 확인
- 기대 결과: 3단계가 순차적으로 실행되고 모두 성공

### Step 2: Build 실패 시나리오 테스트
- 참고 파일: `2.hello-pipeline_build-failure.yaml`
- 내용: build Job에서 의도적으로 실패를 발생시킴
- Push 후 Actions 탭에서 결과 확인
- 기대 결과: build 실패 → deploy가 실행되지 않음 (의존성 동작 확인)

### Step 3: Job 간 변수 전달 파이프라인
- 참고 파일: `3.hello-pipeline_build-pass-variables.yaml`
- 내용: Job의 output을 다른 Job에서 참조하는 방법 학습
- Push 후 Actions 탭에서 변수가 전달된 것 확인
- 기대 결과: 변수가 Job 간 정상 전달됨

### Step 4: 조건부 실행 및 실패 시 알림
- 참고 파일: `4.hello-pipeline_build-pass-variables-failure.yaml`
- 내용: 빌드 실패 시 조건부 알림 처리
- Push 후 Actions 탭에서 확인
- 기대 결과: 실패 조건에 따라 알림 Job이 동작함

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| 기본 파이프라인 | Actions 탭 > 파이프라인 그래프 | test → build → deploy 순차 실행, 모두 성공 |
| 실패 시나리오 | Actions 탭 > 파이프라인 그래프 | build 실패 (빨간색), deploy 미실행 (회색) |
| 변수 전달 | Actions 탭 > 실행 로그 | 전달된 변수 값이 출력됨 |
| 조건부 실행 | Actions 탭 > 파이프라인 그래프 | 조건에 따라 알림 Job 실행 여부 확인 |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| `<github_username>` | 수강생의 GitHub 사용자명 (Actions URL 확인 시) | ❌ 반드시 수강생에게 확인 |

## 주의사항 (Cautions)
- ⛔ AI가 하지 말아야 할 것: 4개의 yaml 파일을 한 번에 모두 제공하지 말 것 — 단계별로 하나씩 진행
- ⛔ AI가 하지 말아야 할 것: Step 2의 의도적 실패를 "수정"해주지 말 것 — 실패를 관찰하는 것이 학습 목표
- ✅ AI가 해도 되는 것: `needs` 키워드의 동작 원리 설명
- ✅ AI가 해도 되는 것: Job 간 변수 전달 메커니즘 (outputs) 설명
- ✅ AI가 해도 되는 것: yaml 문법 오류 디버깅
