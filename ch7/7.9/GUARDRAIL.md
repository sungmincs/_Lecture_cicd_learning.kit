# GUARDRAIL: 7.9 [Jenkins] Worklog App 배포해보기

## 범위 (Scope)
### 이 단계에서 다루는 것
- Jenkins를 사용한 Worklog Frontend 빌드/배포 파이프라인
- Jenkins를 사용한 Worklog Backend 빌드/테스트/배포 파이프라인
- Jenkins Credentials를 활용한 Docker Hub, kubeconfig 관리
- `kubectl set image`를 통한 롤링 업데이트 배포

### 이 단계에서 다루지 않는 것
- GitHub Actions 기반 배포 (8.3에서 다룸)
- GitLab 기반 배포 (8.5에서 다룸)
- MongoDB의 CI/CD 파이프라인 (DB는 수동 배포)

## 사전 조건 (Prerequisites)
- ch5/5.3.x 완료 (Jenkins 파이프라인 이해)
- ch7/7.7 완료 (MongoDB, Backend, Frontend가 K8s에 배포된 상태)
- Jenkins에 Docker Hub credentials 등록 (dockerhub-credentials)
- Jenkins에 kubeconfig Secret file 등록 (kube-config)

## 순서 (Sequence)
### Step 1: Jenkins Credentials 등록 [학습자 직접]
- Dashboard -> Jenkins 관리 -> Credentials
- `dockerhub-credentials`: Username with password (Docker Hub)
- `kube-config`: Secret file (kubeconfig 파일)
- 기대 결과: Credentials 등록 완료

### Step 2: Frontend 파이프라인 적용 [학습자 직접]
- 명령어: `cp ~/_Lecture_cicd_learning.kit/ch7/7.9/1.frontend-build-deploy.groovy Jenkinsfile`
- 명령어: `git add . && git commit -m "cicd: add frontend Jenkins pipeline" && git push origin main`
- 기대 결과: Jenkins에서 파이프라인 자동 감지 및 실행

### Step 3: Backend 파이프라인 적용 [학습자 직접]
- 명령어: `cp ~/_Lecture_cicd_learning.kit/ch7/7.9/2.backend-build-deploy.groovy Jenkinsfile`
- 명령어: `git add . && git commit -m "cicd: add backend Jenkins pipeline" && git push origin main`
- 기대 결과: Jenkins에서 파이프라인 자동 감지 및 실행

### Step 4: 파이프라인 트리거 [학습자 직접]
- Dashboard -> Scan Multibranch Pipeline Now
- 기대 결과: Frontend, Backend 파이프라인 모두 성공

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| Credentials | Jenkins -> Credentials | dockerhub-credentials, kube-config 존재 |
| Frontend 파이프라인 | Jenkins Dashboard | Init -> Build Image -> Deploy 성공 |
| Backend 파이프라인 | Jenkins Dashboard | Init -> Run Test -> Build Image -> Deploy 성공 |
| 이미지 확인 | Docker Hub | frontend, backend 이미지 새 태그 존재 |
| K8s 배포 | `kubectl get pods` | frontend, backend Pod Running |
| 통합 테스트 | 브라우저 접속 | worklog-frontend.myk8s.local 정상 동작 |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| `dockerhub-credentials` | Jenkins Credential ID (Docker Hub) | ❌ 반드시 확인 필요 |
| `kube-config` | Jenkins Credential ID (kubeconfig) | ❌ 반드시 확인 필요 |

## 주의사항 (Cautions)
- ⛔ Jenkins Credentials ID가 Jenkinsfile의 credentials() 호출과 정확히 일치해야 한다
- ⛔ kubeconfig 파일은 Jenkins Secret file로 등록 — 저장소에 커밋하지 않는다
- ✅ Backend 테스트는 Docker agent (python:3.12.3-slim-bookworm)에서 실행된다
- ✅ 8.2에서 배포한 Deployment가 이미 존재해야 `kubectl set image`가 동작한다
