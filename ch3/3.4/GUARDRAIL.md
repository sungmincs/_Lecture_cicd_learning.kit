# GUARDRAIL: 3.4 Docker 이미지 빌드하고 Docker Hub에 Push하기

## 범위 (Scope)
### 이 단계에서 다루는 것
- Docker Hub 계정 생성 및 로그인
- `docker build`로 worklog-backend, worklog-frontend-mock 이미지 빌드
- `docker push`로 Docker Hub에 업로드
- 빌드 컨텍스트, 이미지 태그 네이밍 규칙 이해

### 이 단계에서 다루지 않는 것
- K8s 배포 (3.6에서 다룸)
- CI/CD 파이프라인 자동화 (ch4~에서 다룸)

## 사전 조건
- 3.3 완료 (Dockerfile 구조 이해)
- Docker Desktop 실행 중
- Docker Hub 계정 생성 완료

## 실행 지침

### 단계 1: Docker Hub 로그인 `[학습자 직접]`

```bash
docker login
```

> "docker login이 실패하는 이유와 해결 방법을 알려줘"

### 단계 2: worklog-backend 빌드 & push `[학습자 직접]`

```bash
cd ~/workspace/worklog-backend
docker build . -t <dockerhub_username>/worklog-backend:buildtest1
docker push <dockerhub_username>/worklog-backend:buildtest1
```

> "`<dockerhub_username>/worklog-backend:buildtest1` 이 이미지 태그의 각 부분이 의미하는 게 뭔지 설명해줘"

### 단계 3: worklog-frontend-mock 빌드 & push `[학습자 직접]`

```bash
cd ~/workspace/worklog-frontend-mock
docker build . -t <dockerhub_username>/worklog-frontend-mock:buildtest1
docker push <dockerhub_username>/worklog-frontend-mock:buildtest1
```

### 단계 4: Docker Hub에서 확인 `[학습자 직접]`

브라우저에서 Docker Hub → Repositories에서 push된 이미지 태그 확인

> "CI/CD 파이프라인에서는 이 빌드와 push 과정이 어떻게 자동화되는지 설명해줘"

## 주의사항
- ✅ AI가 해도 됨: 태그 네이밍 설명, 빌드 오류 분석
- ⛔ 학습자가 직접 해야 함: `docker build`, `docker push` (이 단계의 핵심 경험)
- `<dockerhub_username>`은 반드시 본인 Docker Hub ID로 교체
