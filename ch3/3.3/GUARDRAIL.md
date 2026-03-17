# GUARDRAIL: 3.3 Docker 이미지 빌드 및 Docker Hub에 Push

## 범위 (Scope)
### 이 단계에서 다루는 것
- Docker Hub 가입 및 로그인
- Frontend Docker 이미지 빌드
- Push 실패 경험 (의도된 학습 포인트)
- docker login 후 push 성공
- Backend Docker 이미지 빌드 및 push
- Docker Hub 웹에서 이미지 확인

### 이 단계에서 다루지 않는 것
- K8s 배포 (3.4에서 다룸)
- CI/CD 파이프라인 (ch4 이후)
- Dockerfile 작성법 (이미 제공된 Dockerfile 사용)

## 사전 조건 (Prerequisites)
- ch3/3.2 완료 (Docker 설치, worklog-frontend_v1 및 worklog-backend_v1 clone 완료)
- Docker Hub 계정 (이 단계에서 생성 가능)

## 순서 (Sequence)

### Step 1: Docker Hub 가입/로그인
- https://hub.docker.com/ 에서 가입 또는 로그인
- 기대 결과: Docker Hub 계정 준비 완료

### Step 2: Frontend 이미지 빌드
- 명령어:
  ```bash
  cd ~/workspace/worklog-frontend
  docker build . -t <dockerhub_username>/worklog-frontend:buildtest1
  ```
- 기대 결과: 이미지 빌드 성공

### Step 3: Push 시도 (의도적 실패)
- 명령어:
  ```bash
  docker push <dockerhub_username>/worklog-frontend:buildtest1
  ```
- 기대 결과: `denied: requested access to the resource is denied` 에러 발생
- **이 실패는 의도된 학습 포인트임**

### Step 4: Docker Login 후 Push 성공
- 명령어:
  ```bash
  docker login
  docker push <dockerhub_username>/worklog-frontend:buildtest1
  ```
- 기대 결과: Push 성공

### Step 5: Backend 이미지 빌드 및 Push
- 명령어:
  ```bash
  cd ~/workspace/worklog-backend
  docker build . -t <dockerhub_username>/worklog-backend:buildtest1
  docker push <dockerhub_username>/worklog-backend:buildtest1
  ```
- 기대 결과: Backend 이미지 빌드 및 push 성공

### Step 6: Docker Hub에서 확인
- https://hub.docker.com 에서 push된 이미지 확인
- 기대 결과: worklog-frontend, worklog-backend 리포지토리가 Docker Hub에 표시됨

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| 이미지 빌드 | `docker images` | worklog-frontend:buildtest1, worklog-backend:buildtest1 존재 |
| Push 확인 | https://hub.docker.com 에서 확인 | 두 이미지가 Docker Hub에 표시 |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| `<dockerhub_username>` | 수강생의 Docker Hub 사용자명 | ❌ 반드시 수강생에게 확인 |

## 주의사항 (Cautions)
- ⛔ AI가 하지 말아야 할 것: **첫 push 전에 미리 `docker login`을 안내하지 말 것** — Step 3의 push 실패는 의도된 학습 포인트로, 수강생이 "인증 없이 push하면 실패한다"는 것을 직접 경험해야 함
- ⛔ AI가 하지 말아야 할 것: `<dockerhub_username>`을 임의로 채우지 말 것
- ⛔ AI가 하지 말아야 할 것: Step 3의 에러를 "문제"로 취급하여 바로 해결책을 제시하지 말 것 — 에러가 발생하는 이유를 먼저 설명하고, 그 다음 Step 4로 진행
- ✅ AI가 해도 되는 것: 빌드 과정에서 발생하는 실제 오류(네트워크, Dockerfile 문법 등)에 대한 트러블슈팅
- ✅ AI가 해도 되는 것: docker images 명령으로 빌드 결과 확인 안내
