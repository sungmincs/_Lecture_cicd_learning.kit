# GUARDRAIL: 8.5 [GitLab] Worklog App 배포해보기

## 범위 (Scope)
### 이 단계에서 다루는 것
- GitLab CI/CD를 사용한 Worklog Frontend 빌드/배포 파이프라인
- GitLab CI/CD를 사용한 Worklog Backend 빌드/테스트/배포 파이프라인
- GitLab CI/CD Variables를 활용한 Docker Hub, kubeconfig 관리
- `kubectl set image`를 통한 롤링 업데이트 배포

### 이 단계에서 다루지 않는 것
- GitHub Actions 기반 배포 (8.3에서 다룸)
- Jenkins 기반 배포 (8.4에서 다룸)
- MongoDB의 CI/CD 파이프라인 (DB는 수동 배포)

## 사전 조건 (Prerequisites)
- ch5/5.4.x 완료 (GitLab CI/CD 파이프라인 이해)
- ch8/8.2 완료 (MongoDB, Backend, Frontend가 K8s에 배포된 상태)
- Docker Hub 계정 및 Access Token 준비
- GitLab에 worklog-frontend, worklog-backend 저장소 존재

## 순서 (Sequence)
### Step 1: GitLab CI/CD Variables 등록 (두 저장소 모두)
- Settings -> CI/CD -> Variables
- `DOCKERHUB_USERNAME`: Docker Hub 사용자명
- `DOCKERHUB_TOKEN`: Docker Hub Access Token
- `KUBE_CONFIG`: kubeconfig (base64 인코딩)
- 기대 결과: 각 저장소에 Variables 등록 완료

### Step 2: Frontend 파이프라인 적용
- 명령어: `cp ~/_Lecture_cicd_learning.kit/ch8/8.4/1.frontend-build-deploy.yml .gitlab-ci.yml`
- 명령어: `git add . && git commit -m "cicd: add frontend GitLab pipeline" && git push origin main`
- 기대 결과: GitLab 파이프라인 자동 트리거, Frontend 이미지 빌드 및 배포

### Step 3: Backend 파이프라인 적용
- 명령어: `cp ~/_Lecture_cicd_learning.kit/ch8/8.4/2.backend-build-deploy.yml .gitlab-ci.yml`
- 명령어: `git add . && git commit -m "cicd: add backend GitLab pipeline" && git push origin main`
- 기대 결과: GitLab 파이프라인 자동 트리거, Backend 이미지 빌드/테스트 및 배포

### Step 4: 전체 통합 검증
- GitLab CI/CD -> Pipelines에서 두 파이프라인 성공 확인
- 접속: `http://worklog-frontend.myk8s.local`
- 기대 결과: Frontend -> Backend -> MongoDB 연결 정상 동작

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| Variables | GitLab Settings -> CI/CD -> Variables | DOCKERHUB_USERNAME, DOCKERHUB_TOKEN, KUBE_CONFIG 존재 |
| Frontend 파이프라인 | GitLab Pipelines | build -> deploy 성공 |
| Backend 파이프라인 | GitLab Pipelines | test -> build -> deploy 성공 |
| 이미지 확인 | Docker Hub | frontend, backend 이미지 새 태그 존재 |
| K8s 배포 | `kubectl get pods` | frontend, backend Pod Running |
| 통합 테스트 | 브라우저 접속 | worklog-frontend.myk8s.local 정상 동작 |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| `DOCKERHUB_USERNAME` | Docker Hub 사용자명 (GitLab Variable) | ❌ 반드시 확인 필요 |
| `DOCKERHUB_TOKEN` | Docker Hub Access Token (GitLab Variable) | ❌ 반드시 확인 필요 |
| `KUBE_CONFIG` | kubeconfig base64 (GitLab Variable) | ❌ 반드시 확인 필요 |

## 주의사항 (Cautions)
- ⛔ kubeconfig를 저장소에 커밋하지 않는다 — 반드시 GitLab CI/CD Variables 사용
- ⛔ KUBE_CONFIG는 base64 인코딩된 값이어야 한다
- ⛔ Docker-in-Docker(dind) 서비스가 필요하므로 GitLab Runner에 privileged 모드 설정 필요
- ✅ Frontend와 Backend는 독립 저장소에서 독립 파이프라인으로 운영된다
- ✅ 8.2에서 배포한 Deployment가 이미 존재해야 `kubectl set image`가 동작한다
