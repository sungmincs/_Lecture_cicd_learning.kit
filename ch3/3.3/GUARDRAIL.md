# GUARDRAIL: 3.3 Worklog 앱의 Dockerfile 이해하기

## 범위 (Scope)
### 이 단계에서 다루는 것
- worklog-backend, worklog-frontend의 Dockerfile 구조 분석
- 멀티스테이지 빌드 개념 이해 (frontend: Node→Nginx, backend: Python/uv 기반)
- Docker 이미지 레이어와 빌드 캐시 이해
- "왜 이렇게 Dockerfile이 작성됐는가" — CI/CD 빌드 시간과의 연결

### 이 단계에서 다루지 않는 것
- 실제 Docker 빌드 명령 실행 (3.4에서 다룸)
- K8s 배포 (3.6에서 다룸)

## 사전 조건
- 3.2 완료 (Worklog 앱 로컬 실행 확인)
- Docker 설치 완료 (ch2에서 구성)

## 실행 지침

### 단계 1: backend Dockerfile 분석 `[학습자 직접]`

```bash
cat ~/workspace/worklog-backend/Dockerfile
```

> "이 Dockerfile이 어떤 구조로 되어 있는지 설명해줘"

### 단계 2: frontend Dockerfile 분석 `[AI 프롬프트]`

> "worklog-frontend Dockerfile의 멀티스테이지 빌드 구조를 설명해줘. 왜 두 단계로 나눴는지 이유도 알려줘"

### 단계 3: 레이어 캐시 이해 `[AI 프롬프트]`

> "Dockerfile에서 COPY 명령의 순서가 왜 중요한지, CI/CD 빌드 시간과 어떤 관계가 있는지 설명해줘"

## 주의사항
- ✅ AI가 해도 됨: Dockerfile 구조 설명, 레이어 개념 설명
- ⛔ AI가 하지 말 것: Dockerfile을 임의로 수정하지 말 것 (기존 파일 분석이 목적)
