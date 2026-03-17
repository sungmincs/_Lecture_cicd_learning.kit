# GUARDRAIL: 4.8 GitLab CI/CD 빌드 파이프라인 구조 만들기

## 범위 (Scope)
### 이 단계에서 다루는 것
- GitLab CI/CD 파이프라인의 stages 정의
- `needs` 키워드를 사용한 병렬/순차 실행 제어
- 실패 시나리오 테스트
- dotenv artifact를 사용한 Job 간 변수 전달
- YAML anchor(&, *)를 사용한 코드 재사용

### 이 단계에서 다루지 않는 것
- 실제 Docker 빌드 (ch5에서 다룸)
- GitLab Extension 활용 (5.7에서 다룸)
- GitHub Actions, Jenkins
- `.pre`/`.post` stage (특수한 경우가 아니면 사용하지 않음)

## 사전 조건 (Prerequisites)
- ch4/4.7 완료 (GitLab 가입, SSH 키 설정, worklog-backend-gitlab clone 완료)

## 순서 (Sequence)

### Step 1: 기본 3단계 파이프라인
- 참고 파일: `1.hello-pipeline.yml`
- 내용: stages 정의 (test, build, deploy), 각 stage에 Job 배치
- 명령어:
  ```bash
  cd worklog-backend-gitlab
  cp ~/_Lecture_cicd_learning.kit/ch4/4.8/1.hello-pipeline.yml .gitlab-ci.yml
  git add . && git commit -m "basic 3-stage pipeline" && git push origin main
  ```
- 기대 결과: 3단계가 순차 실행되고 모두 성공

### Step 2: Stage + Needs를 사용한 병렬/순차 실행
- 참고 파일: `2.hello-pipeline-stage-and-needs.yml`
- 내용: `needs` 키워드로 Job 간 의존성을 세밀하게 제어
- Push 후 GitLab Pipelines UI에서 그래프 확인
- 기대 결과: 의존성에 따라 일부 Job이 병렬 실행되는 것을 확인

### Step 3: 실패 시나리오
- 참고 파일: `3.hello-pipeline_build-failure.yml`
- 내용: build Job에서 의도적으로 실패
- Push 후 결과 확인
- 기대 결과: build 실패 → 의존하는 Job 미실행

### Step 4: dotenv Artifact로 변수 전달
- 참고 파일: `4.hello-pipeline_build-pass-variables.yml`
- 내용: `artifacts:reports:dotenv`를 사용하여 Job 간 변수 전달
- 참고 문서: https://docs.gitlab.com/ee/ci/yaml/artifacts_reports.html#artifactsreportsdotenv
- Push 후 결과 확인
- 기대 결과: 이전 Job에서 설정한 변수가 다음 Job에서 사용됨

### Step 5: YAML Anchor로 코드 재사용
- 참고 파일: `5.hello-pipeline_build-pass-variables-anchor.yml`
- 내용: YAML anchor(`&`)와 alias(`*`)를 사용하여 중복 코드 제거
- Push 후 결과 확인
- 기대 결과: anchor로 재사용된 설정이 정상 동작

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| 기본 파이프라인 | GitLab > Build > Pipelines > 그래프 | test → build → deploy 순차 실행, 모두 성공 |
| Stage + Needs | GitLab > Pipelines > 그래프 | 병렬/순차 실행 구조 시각적 확인 |
| 실패 시나리오 | GitLab > Pipelines > 그래프 | build 실패 (빨간색), 의존 Job 미실행 |
| 변수 전달 | GitLab > Pipelines > Job 로그 | 전달된 변수 값 정상 출력 |
| YAML Anchor | GitLab > Pipelines | anchor 적용된 파이프라인 정상 동작 |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| (없음) | | |

## 주의사항 (Cautions)
- ⛔ AI가 하지 말아야 할 것: 5개의 yml 파일을 한 번에 모두 제공하지 말 것 — 단계별로 하나씩 진행
- ⛔ AI가 하지 말아야 할 것: Step 3의 의도적 실패를 "수정"해주지 말 것 — 실패를 관찰하는 것이 학습 목표
- ⛔ AI가 하지 말아야 할 것: `.pre`/`.post` stage 사용을 권장하지 말 것 — 특수한 경우가 아니면 사용하지 않음
- ✅ AI가 해도 되는 것: `stages`, `needs`, `artifacts:reports:dotenv` 문법 설명
- ✅ AI가 해도 되는 것: YAML anchor/alias 문법 설명
- ✅ AI가 해도 되는 것: GitLab Pipelines UI 탐색 방법 안내
- ✅ AI가 해도 되는 것: .gitlab-ci.yml 문법 오류 디버깅
