# GUARDRAIL: 4.6 Jenkins 빌드 파이프라인 구조 만들기

## 범위 (Scope)
### 이 단계에서 다루는 것
- Jenkins 파이프라인의 Stage 의존성과 구조
- 기본 3단계 파이프라인 (test → build → deploy)
- Build 실패 시 Post-build 알림 처리
- Stage 간 변수 전달
- 재사용 가능한 함수(Shared Library 패턴) 활용

### 이 단계에서 다루지 않는 것
- 실제 Docker 빌드 (ch5에서 다룸)
- Jenkins Plugin 활용 (5.5에서 다룸)
- GitHub Actions, GitLab CI/CD

## 사전 조건 (Prerequisites)
- ch4/4.5 완료 (Jenkins 설치 + Multibranch Pipeline 생성)

## 순서 (Sequence)

### Step 1: 기본 3단계 파이프라인
- 참고 파일: `Jenkinsfiles/1.hello-pipeline.groovy`
- 내용: test → build → deploy 순서로 실행되는 3개의 Stage
- worklog-backend 리포지토리의 Jenkinsfile을 업데이트하고 push
- 기대 결과: Stage View에서 3단계가 순차 실행되고 모두 성공

### Step 2: Build 실패 + Post-build 알림
- 참고 파일: `Jenkinsfiles/2.hello-pipeline_build-failure.groovy`
- 내용: build Stage에서 의도적으로 실패, post 블록에서 알림 처리
- Push 후 Jenkins UI에서 결과 확인
- 기대 결과: build 실패 → deploy 미실행, post 블록의 failure 핸들러 동작

### Step 3: Stage 간 변수 전달
- 참고 파일: `Jenkinsfiles/3.hello-pipeline_build-pass-variables.groovy`
- 내용: environment 블록과 script 블록을 사용하여 Stage 간 변수 전달
- Push 후 Jenkins UI에서 결과 확인
- 기대 결과: 변수가 Stage 간 정상 전달됨

### Step 4: 재사용 가능한 함수 활용
- 참고 파일: `Jenkinsfiles/4.hello-pipeline_build-pass-variables-function.groovy`
- 내용: Groovy 함수를 정의하여 반복 로직을 재사용
- Push 후 Jenkins UI에서 결과 확인
- 기대 결과: 함수 호출이 정상 동작하고 파이프라인 성공

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| 기본 파이프라인 | Jenkins > Stage View | test → build → deploy 순차 실행, 모두 녹색 |
| 실패 시나리오 | Jenkins > Stage View | build 빨간색, deploy 미실행, post 알림 동작 |
| 변수 전달 | Jenkins > Console Output | 전달된 변수 값이 출력됨 |
| 함수 활용 | Jenkins > Console Output | 함수 호출 결과 정상 출력 |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| (없음) | | |

## 주의사항 (Cautions)
- ⛔ AI가 하지 말아야 할 것: 4개의 Jenkinsfile을 한 번에 모두 제공하지 말 것 — 단계별로 하나씩 진행
- ⛔ AI가 하지 말아야 할 것: Step 2의 의도적 실패를 "수정"해주지 말 것 — 실패를 관찰하고 post 블록 동작을 확인하는 것이 학습 목표
- ⛔ AI가 하지 말아야 할 것: Jenkins UI 조작을 수강생 대신 수행하지 말 것
- ✅ AI가 해도 되는 것: Jenkinsfile(Declarative Pipeline) 문법 설명
- ✅ AI가 해도 되는 것: post 블록의 조건 (always, success, failure) 설명
- ✅ AI가 해도 되는 것: Groovy 문법 관련 질문 답변
