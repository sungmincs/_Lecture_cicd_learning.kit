# GUARDRAIL: 3.2 Docker 설치 및 Worklog 샘플 앱 로컬 실행

## 범위 (Scope)
### 이 단계에서 다루는 것
- Docker CE 설치 (control plane 노드)
- GitHub에서 worklog-frontend_v1, worklog-backend_v1 리포지토리 fork
- Control plane 노드에서 git clone
- docker compose로 Worklog 앱 로컬 실행

### 이 단계에서 다루지 않는 것
- Docker 이미지 빌드 (3.3에서 다룸)
- K8s 배포 (3.4에서 다룸)
- CI/CD 파이프라인 구성

## 사전 조건 (Prerequisites)
- ch2 환경 구성 완료 (Vagrant + VirtualBox로 K8s 클러스터 가동 중)
- GitHub 계정 보유

## 순서 (Sequence)

### Step 1: Docker CE 설치
- 명령어:
  ```bash
  apt update && apt install docker-ce -y
  ```
- 기대 결과: Docker가 설치됨

### Step 2: GitHub 리포지토리 Fork
- https://github.com/sungmincs/worklog-frontend_v1 fork
- https://github.com/sungmincs/worklog-backend_v1 fork
- **중요**: Fork 시 "Copy the main branch only" 체크를 **해제**해야 함
- 기대 결과: 수강생의 GitHub 계정에 두 리포지토리가 fork됨

### Step 3: Control Plane 노드에서 Clone
- 명령어:
  ```bash
  mkdir ~/workspace
  cd ~/workspace
  git clone https://github.com/<github_username>/worklog-frontend_v1.git
  git clone https://github.com/<github_username>/worklog-backend_v1.git
  ```
- 기대 결과: ~/workspace 디렉토리에 두 리포지토리가 clone됨

### Step 4: Docker Compose로 앱 실행
- 명령어:
  ```bash
  cd ~/workspace/worklog-frontend_v1
  docker compose up
  ```
- 기대 결과: Frontend, Backend, Database가 모두 실행됨

### Step 5: 브라우저에서 확인
- Frontend: http://192.168.1.10:8080
- Backend: http://192.168.1.10:8000
- 기대 결과: Worklog 앱 UI가 정상 표시됨

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| Docker 설치 | `docker --version` | Docker 버전 정보 출력 |
| Fork 확인 | GitHub 웹에서 수강생 계정 확인 | 두 리포지토리 존재, 브랜치가 main 외에도 있음 |
| Clone 확인 | `ls ~/workspace/` | worklog-frontend_v1, worklog-backend_v1 디렉토리 존재 |
| 앱 실행 | http://192.168.1.10:8080 접속 | Worklog 앱 UI 표시 |
| Backend | http://192.168.1.10:8000 접속 | Backend API/Swagger 표시 |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| `<github_username>` | 수강생의 GitHub 사용자명 | ❌ 반드시 수강생에게 확인 |

## 주의사항 (Cautions)
- ⛔ AI가 하지 말아야 할 것: `<github_username>`을 임의로 채우지 말 것
- ⛔ AI가 하지 말아야 할 것: Fork 시 "Copy the main branch only" 체크를 해제하라는 안내를 누락하지 말 것 — 이후 단계에서 다른 브랜치가 필요함
- ✅ AI가 해도 되는 것: docker compose 실행 시 발생하는 일반적인 오류에 대한 트러블슈팅 안내
- ✅ AI가 해도 되는 것: docker compose up 실행 후 로그 해석 안내
