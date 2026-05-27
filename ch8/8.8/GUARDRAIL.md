# GUARDRAIL: 8.8 [GitLab] PR/Branch/Tag 기반 배포 파이프라인 만들기

## 범위 (Scope)
### 이 단계에서 다루는 것
- GitLab CI/CD를 사용한 멀티 환경 배포 파이프라인 구현
- Merge Request 이벤트 → dev namespace 배포
- Branch push (develop → dev, release/* → staging) 배포
- Tag push (v*.*.* → prod) 배포
- GitLab CI/CD variables를 활용한 Docker Hub, kubeconfig 관리

### 이 단계에서 다루지 않는 것
- Argo CD 연동 (8.9에서 다룸)
- GitHub Actions / Jenkins 기반 파이프라인 (8.4~8.5, 8.6~8.7에서 다룸)
- GitLab environments를 이용한 배포 추적
- 환경별 approval gate (수동 승인 프로세스)

## 사전 조건 (Prerequisites)
- ch5/5.6 또는 5.7 완료 (GitLab CI/CD 빌드/배포 파이프라인 기본 이해)
- ch8/8.2 완료 (dev, staging, prod namespace 생성)
- ch8/8.3 완료 (develop, release/1.0 브랜치 생성)
- GitLab CI/CD Variables 등록: DOCKERHUB_USERNAME, DOCKERHUB_TOKEN, KUBE_CONFIG

## 순서 (Sequence)
### Step 1: 멀티 환경 파이프라인 파일 복사
- 명령어: `cp ~/_Lecture_cicd_learning.kit/ch8/8.8/1.multi-env-pipeline.yml .gitlab-ci.yml`
- 기대 결과: 프로젝트 루트에 .gitlab-ci.yml 생성/덮어쓰기

### Step 2: 코드 커밋 및 푸시
- 명령어: `git add . && git commit -m "cicd: add multi-environment GitLab pipeline" && git push origin main`
- 기대 결과: GitLab CI/CD가 main push 이벤트로 자동 트리거

### Step 3: MR 기반 배포 테스트
- feature 브랜치 생성 후 GitLab UI에서 Merge Request 생성
- 기대 결과: MR 이벤트로 dev namespace에 배포

### Step 4: Tag 기반 배포 테스트
- 명령어: `git tag v1.0.0 && git push origin v1.0.0`
- 기대 결과: prod namespace에 v1.0.0 태그로 배포

### Step 5: 배포 확인
- 명령어: `kubectl get pods -n dev`, `kubectl get pods -n staging`, `kubectl get pods -n prod`
- 기대 결과: 각 namespace에서 worklog-backend Pod가 Running 상태

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| 파이프라인 트리거 | GitLab CI/CD → Pipelines 확인 | 파이프라인이 자동 실행됨 |
| 환경 판별 | deploy job 로그 | 올바른 TARGET_ENV/TARGET_NAMESPACE 출력 |
| 이미지 빌드 | Docker Hub 저장소 확인 | 환경별 태그로 이미지 존재 |
| dev 배포 | `kubectl get pods -n dev` | worklog-backend Pod Running |
| staging 배포 | `kubectl get pods -n staging` | worklog-backend Pod Running |
| prod 배포 | `kubectl get pods -n prod` | worklog-backend Pod Running |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| `DOCKERHUB_USERNAME` | GitLab CI/CD Variable로 등록된 Docker Hub 사용자 이름 | ❌ 반드시 확인 필요 |
| `DOCKERHUB_TOKEN` | GitLab CI/CD Variable로 등록된 Docker Hub 토큰 | ❌ 반드시 확인 필요 |
| `KUBE_CONFIG` | GitLab CI/CD Variable로 등록된 base64 인코딩된 kubeconfig | ❌ 반드시 확인 필요 |

## 주의사항 (Cautions)
- ⛔ GitLab CI/CD Variables에 DOCKERHUB_USERNAME, DOCKERHUB_TOKEN, KUBE_CONFIG가 등록되어 있어야 한다.
- ⛔ KUBE_CONFIG는 base64로 인코딩된 값이어야 한다. 파이프라인에서 디코딩하여 사용한다.
- ⛔ prod namespace 배포는 태그 push 시에만 동작한다. 실수로 태그를 만들지 않도록 주의한다.
- ✅ workflow:rules로 파이프라인 실행 조건을 제어하므로, 불필요한 브랜치에서 파이프라인이 실행되지 않는다.
- ✅ docker:24-dind 서비스를 사용하므로 GitLab Runner에 Docker-in-Docker가 지원되어야 한다.
