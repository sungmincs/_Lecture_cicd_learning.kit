# GUARDRAIL: 5.6 [GitLab] 빌드 파이프라인 실제로 구현하기

## 범위 (Scope)
### 이 단계에서 다루는 것
- GitLab CI/CD로 Docker 이미지 빌드 및 Docker Hub push 파이프라인 구현
- GitLab CI/CD Variables를 활용한 민감 정보(Docker Hub 토큰, kubeconfig) 관리
- Docker-in-Docker (DinD) 서비스를 활용한 이미지 빌드
- dotenv artifact를 통한 job 간 변수 전달
- 커밋 메타데이터를 활용한 이미지 태깅 전략
- 파이프라인 성공/실패 알림 구현

### 이 단계에서 다루지 않는 것
- GitLab extends/includes를 활용한 간소화 (5.7에서 다룸)
- GitHub Actions 또는 Jenkins 기반 파이프라인 (5.2~5.3, 5.4~5.5에서 다룸)
- GitLab Runner 설치 및 구성 (ch4/4.7~4.8에서 완료)
- GitLab Container Registry 사용 (Docker Hub 사용)

## 사전 조건 (Prerequisites)
- ch4/4.7, 4.8 완료 (GitLab CI/CD 기본 구성 및 파이프라인 이해)
- Docker Hub 계정 생성 및 Access Token 발급
- worklog-backend-gitlab 저장소가 GitLab에 fork 및 clone된 상태
- Kubernetes 클러스터 접속 가능 (kubeconfig 준비)
- GitLab Runner가 Docker executor 또는 Kubernetes executor로 설정된 상태

## 순서 (Sequence)
### Step 1: GitLab CI/CD Variables 등록 [AI 프롬프트]
- Settings → CI/CD → Variables → Add variable
- `DOCKERHUB_USERNAME`: Docker Hub 사용자 이름 (Protected: No, Masked: No)
- `DOCKERHUB_TOKEN`: Docker Hub Access Token (Protected: No, Masked: Yes)
- 기대 결과: Variables 목록에 2개 항목 확인

### Step 2: 파이프라인 YAML 파일 복사 [학습자 직접]
- 명령어: `cp ~/_Lecture_cicd_learning.kit/ch5/5.6/1.build-pipeline.yml .gitlab-ci.yml`
- 기대 결과: 프로젝트 루트에 `.gitlab-ci.yml` 파일 생성

### Step 3: 코드 커밋 및 푸시 [학습자 직접]
- 명령어: `git add . && git commit -m "cicd: add build pipeline" && git push origin main`
- 기대 결과: GitLab CI/CD 파이프라인이 자동으로 트리거됨

### Step 4: 파이프라인 실행 결과 확인 [학습자 직접]
- GitLab → CI/CD → Pipelines에서 파이프라인 실행 상태 확인
- 기대 결과: init → test → build → notify-success 순서로 실행 완료

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| Variables 등록 | GitLab Settings → CI/CD → Variables | DOCKERHUB_USERNAME, DOCKERHUB_TOKEN 존재 |
| 파이프라인 트리거 | GitLab CI/CD → Pipelines | 파이프라인이 자동 실행됨 |
| init job | init job 로그 확인 | dotenv artifact에 FULL_SHA, SHORT_SHA 등 출력 |
| 테스트 통과 | test job 로그 확인 | poetry test 성공, coverage 출력 |
| 이미지 빌드 | Docker Hub 저장소 확인 | full_sha, short_sha 태그로 이미지 존재 |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| `<dockerhub_username>` | Docker Hub 사용자 이름 | ❌ 반드시 확인 필요 |
| `<dockerhub_token>` | Docker Hub Access Token | ❌ 반드시 확인 필요 |
| `<username>` | GitLab 사용자 이름 | ❌ 반드시 확인 필요 |

## 주의사항 (Cautions)
- ⛔ Docker Hub 토큰을 `.gitlab-ci.yml` 파일에 직접 하드코딩하지 않는다. 반드시 CI/CD Variables를 사용한다.
- ⛔ Docker-in-Docker (DinD) 사용 시 `DOCKER_HOST`와 `DOCKER_TLS_CERTDIR` 변수가 올바르게 설정되어야 한다.
- ⛔ Masked 변수는 로그에서 자동으로 마스킹되지만, echo 등으로 직접 출력하면 노출될 수 있으므로 주의한다.
- ✅ dotenv artifact를 사용하면 job 간 변수 전달이 가능하며, `needs` 키워드로 의존 관계를 명시해야 한다.
- ✅ GitLab CI/CD Variables에서 Masked 옵션을 활성화하면 로그에서 해당 값이 `[MASKED]`로 표시된다.
