# GUARDRAIL: 8.4 [GitHub] PR/Branch/Tag 기반 배포 파이프라인 만들기

## 범위 (Scope)
### 이 단계에서 다루는 것
- GitHub Actions를 사용한 멀티 환경 배포 파이프라인 구현
- PR 이벤트 → dev namespace 배포
- Branch push (develop → dev, release/* → staging) 배포
- Tag push (v*.*.* → prod) 배포
- 환경별 이미지 태깅 전략 (pr-N, dev-SHA, staging-SHA, vX.Y.Z)

### 이 단계에서 다루지 않는 것
- Argo CD 연동 (8.5에서 다룸)
- Jenkins / GitLab 기반 파이프라인 (8.6~8.7, 8.8~8.9에서 다룸)
- Helm 차트를 이용한 환경별 values 파일 분리
- 환경별 approval gate (수동 승인 프로세스)

## 사전 조건 (Prerequisites)
- ch5/5.2 또는 5.3 완료 (GitHub Actions 빌드/배포 파이프라인 기본 이해)
- ch8/8.2 완료 (dev, staging, prod namespace 생성)
- ch8/8.3 완료 (develop, release/1.0 브랜치 생성)
- GitHub Secrets 등록: DOCKERHUB_TOKEN, CP_K8S_CONTEXT

## 순서 (Sequence)
### Step 1: 멀티 환경 파이프라인 파일 복사
- 명령어: `cp ~/_Lecture_cicd_learning.kit/ch8/8.4/1.multi-env-pipeline.yaml .github/workflows/multi-env-pipeline.yaml`
- 기대 결과: `.github/workflows/` 디렉토리에 멀티 환경 파이프라인 파일 생성

### Step 2: YAML 파일에서 플레이스홀더 수정
- `<dockerhub_username>`을 본인 Docker Hub 사용자 이름으로 변경
- 기대 결과: env.DOCKER_REPOSITORY, env.DOCKERHUB_USERNAME 값이 올바르게 설정됨

### Step 3: 코드 커밋 및 푸시
- 명령어: `git add . && git commit -m "cicd: add multi-environment pipeline" && git push origin main`
- 기대 결과: GitHub Actions가 main push 이벤트로 자동 트리거

### Step 4: PR 기반 배포 테스트
- feature 브랜치 생성 후 GitHub UI에서 PR 생성
- 기대 결과: PR 이벤트로 dev namespace에 배포

### Step 5: Tag 기반 배포 테스트
- 명령어: `git tag v1.0.0 && git push origin v1.0.0`
- 기대 결과: prod namespace에 v1.0.0 태그로 배포

### Step 6: 배포 확인
- 명령어: `kubectl get pods -n dev`, `kubectl get pods -n staging`, `kubectl get pods -n prod`
- 기대 결과: 각 namespace에서 worklog-backend Pod가 Running 상태

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| 파이프라인 트리거 | GitHub Actions 탭 확인 | 워크플로우가 자동 실행됨 |
| 환경 판별 | determine-environment job 로그 | 올바른 environment/namespace 출력 |
| 이미지 빌드 | Docker Hub 저장소 확인 | 환경별 태그로 이미지 존재 |
| dev 배포 | `kubectl get pods -n dev` | worklog-backend Pod Running |
| staging 배포 | `kubectl get pods -n staging` | worklog-backend Pod Running |
| prod 배포 | `kubectl get pods -n prod` | worklog-backend Pod Running |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| `<dockerhub_username>` | Docker Hub 사용자 이름 | ❌ 반드시 확인 필요 |

## 주의사항 (Cautions)
- ⛔ `<dockerhub_username>`을 반드시 본인 계정으로 수정해야 한다. 수정하지 않으면 이미지 push가 실패한다.
- ⛔ prod namespace 배포는 태그 push 시에만 동작한다. 실수로 태그를 만들지 않도록 주의한다.
- ✅ PR 이벤트와 push 이벤트가 동시에 발생할 수 있으므로, 중복 실행을 방지하려면 concurrency 설정을 추가한다.
- ✅ 각 환경별로 배포가 정상 동작하는지 순서대로 확인한다 (dev → staging → prod).
