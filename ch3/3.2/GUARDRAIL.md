# GUARDRAIL: 3.2 Worklog 앱을 다운받고 실행해보기

## 범위 (Scope)
### 이 단계에서 다루는 것
- GitHub에서 worklog-frontend-mock, worklog-backend 저장소 Fork
- 클론 후 `docker compose up`으로 앱 로컬 실행
- 브라우저에서 frontend/backend 동작 확인

### 이 단계에서 다루지 않는 것
- Dockerfile 구조 분석 (3.3에서 다룸)
- Docker 이미지 직접 빌드 (3.4에서 다룸)
- K8s 배포 (3.6에서 다룸)

## 사전 조건
- ch2 완료 (K8s 환경 + Docker 설치 완료)
- GitHub 계정 보유 (Fork 필수)
- Docker Hub 계정 보유 (3.4에서 사용 — 미리 가입 권장)

## 실행 지침

### 단계 0: Fork 저장소 `[학습자 직접]`

GitHub에서 아래 두 저장소를 본인 계정으로 Fork:
- https://github.com/sungmincs/worklog-frontend-mock
- https://github.com/sungmincs/worklog-backend

> Fork 시 **"Copy the main branch only" 체크 해제** — 모든 브랜치 포함 필수

### 단계 1: 저장소 클론 `[학습자 직접]`

```bash
mkdir ~/workspace && cd ~/workspace
git clone https://github.com/<github_username>/worklog-frontend-mock.git
git clone https://github.com/<github_username>/worklog-backend.git
```

### 단계 2: 앱 로컬 실행 `[학습자 직접]`

```bash
cd worklog-frontend-mock
docker compose up
```

> "docker compose up이 실행되면서 어떤 컨테이너들이 뜨는지 설명해줘"

### 단계 3: 앱 접속 확인 `[학습자 직접]`

브라우저에서:
- frontend: `http://192.168.1.10:8080`
- backend: `http://192.168.1.10:8000`

worklog 항목 몇 개 추가 후 새로고침으로 정상 동작 확인

### 단계 4: 앱 구조 파악 `[AI 프롬프트]`

> "지금 docker compose로 실행 중인 worklog 앱의 frontend, backend, database가 어떻게 연결되어 있는지 설명해줘"

## 주의사항
- ✅ AI가 해도 됨: 앱 구조 설명, docker compose 파일 해석
- ⛔ 학습자가 직접 해야 함: Fork, git clone, docker compose up, 브라우저 접속
- ch2/2.11에서 Docker가 이미 설치됐으면 `apt install docker-ce` 생략 가능
- docker compose 실행 후 3.3으로 이동 (compose down 하지 말 것 — 구조 파악에 계속 활용)
