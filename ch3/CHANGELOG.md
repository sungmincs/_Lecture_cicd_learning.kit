# ch3 변경 이력

## [2026-05]

### ch3 검토 중 발견 버그 수정 [2026-05-27]

**3.2/.cmd — 저장소 이름 불일치 수정 (pre-existing)**
- Before: `worklog-frontend_v1.git`, `worklog-backend_v1.git` (구버전 repo명)
- After: `worklog-frontend-mock.git`, `worklog-backend.git` (현행 repo명)
- 이유: 3.3~3.7이 `~/workspace/worklog-frontend-mock/` 경로 참조 → 클론 디렉토리명 일치 필요

**3.3/.cmd — 빌드 전 명령어 제거**
- `docker history <image>:buildtest1`, `docker images | grep worklog` → 3.4로 이동
- 이유: 3.3은 Dockerfile 분석 단계. 이미지는 3.4에서 빌드됨

**3.5/.cmd + GUARDRAIL.md — 절대 경로로 수정**
- Before: `cat ch3/3.6/worklog_manifests/...` (상대 경로 → CWD 의존)
- After: `cat ~/_Lecture_cicd_learning.kit/ch3/3.6/worklog_manifests/...`
- 핵심 질문 2에 worklog-mongodb.yaml cat 추가 (base64 값 출처 명시)

**3.6/.cmd — LB 확인 명령 수정**
- Before: `kubectl get svc -n ingress-nginx ingress-nginx-controller` (잘못된 참조)
- After: `kubectl get gateway nginx-gateway -o wide` (NGINX Gateway Fabric 정확한 명령)

**3.6/worklog_manifests/worklog-backend.yaml — Secret 중복 제거**
- `worklog-mongodb-creds` Secret이 worklog-backend.yaml + worklog-mongodb.yaml 양쪽 정의 → worklog-mongodb.yaml에만 유지

**3.8/.cmd + GUARDRAIL.md — 진단 명령 보완**
- 시나리오 1: 재현 명령 주석 해제, `kubectl get pods` 추가
- 시나리오 3: `kubectl get endpoints worklog-backend` 추가
- GUARDRAIL 시나리오 1 복구: `kubectl rollout status` 추가
- .cmd 끝에 cleanup 추가

**Internal 3.8 — Exit Code 143 설명 수정**
- Before: "SIGTERM (정상 종료)" → After: "K8s SIGTERM (liveness 실패·rolling update로 인한 강제 종료)"

---

### ch3 챕터 구조 재편 — 3.2~3.4에서 3.2~3.8로 확장 [2026-05-27]

**변경 배경:**
- 기존 ch3 (3.2~3.4, 3섹션)이 빈약하다는 판단 → 사전 강의 k8s kit 수강자 기준으로 보강
- A방향(학습자가 AI와 함께 처음부터 작성) 기반으로 각 섹션 .cmd + GUARDRAIL.md 신규 작성

**섹션별 변경:**

| 기존 | 신규 | 내용 |
|------|------|------|
| 3.3 (Docker 빌드+K8s 배포) | 3.3 | Dockerfile 분석 (신규 분리) |
| — | 3.4 | Docker 빌드 & push (신규 분리) |
| — | 3.5 | CI/CD 관점 K8s 오브젝트 재이해 (신규) |
| 3.4 (K8s 배포) | 3.6 | K8s 배포 (번호 이동, .cmd 정리) |
| — | 3.7 | 이미지 업데이트 수동 재배포 체험 (신규) |
| — | 3.8 | CI/CD 특화 트러블슈팅 (신규) |

**3.5 설계 의도 (k8s kit과의 차별화):**
- k8s kit: K8s 오브젝트 자체를 가르침 (Deployment, Service, Secret 기본 개념)
- ch3.5: 같은 오브젝트를 "CI/CD 맥락"으로 재해석
  - Deployment → 이미지 태그 교체 = 배포 단위
  - Secret → 파이프라인 로그에 DB 비번이 찍히면 안 되는 이유
  - imagePullSecrets → Docker Hub rate limit + private registry 인증

**3.8 설계 의도 (CI/CD 특화 트러블슈팅):**
- ImagePullBackOff: 파이프라인이 push 전에 deploy하거나 태그 오타
- CrashLoopBackOff: 새 이미지 환경변수 누락, `--previous` 플래그로 첫 오류 확인
- readinessProbe 실패: Pod Running인데 트래픽 차단 → `kubectl rollout status` 타임아웃 원인
- 진단 흐름도: `kubectl get pods` 상태 → 다음 명령 판단

---

### worklog-frontend-mock — `vite.config.ts` `allowedHosts` 추가

> ⚠️ **강의자 필수 확인 사항**
>
> `sungmincs/worklog-frontend-mock` 저장소에 반영 필요. 반영 전 배포 시 브라우저 접속이 **403 Forbidden**으로 차단됨.

- **Before**: `vite.config.ts`에 `server` 설정 없음
- **After**: `server.allowedHosts: [".myk8s.local"]` 추가
- **이유**: Vite 5.4부터 DNS rebinding 방어를 위해 외부 hostname으로 들어오는 요청을 기본 차단. K8s 배포 후 `worklog-frontend.myk8s.local`로 접속 시 Vite가 403을 반환. `allowedHosts`에 `.myk8s.local`을 추가해야 K8s 환경에서 정상 동작.

```ts
// vite.config.ts
export default defineConfig(() => {
  return {
    plugins: [...],
    server: {
      allowedHosts: [".myk8s.local"]
    }
  };
});
```

---

### worklog-backend — Python 3.14 + uv 전환

> ⚠️ **강의자 필수 확인 사항**
>
> `sungmincs/worklog-backend` 저장소의 `Dockerfile`, `pyproject.toml` 반영 필요.

- **Before**: `python:3.12.3-slim-bookworm`, Poetry `1.8.0`
- **After**: `python:3.14-slim-bookworm`, uv `0.11.14`
- **이유**: Python 3.12.3은 고정 patch로 보안 fix 미적용. uv는 2026년 FastAPI 공식 문서 권장 패키지 관리자. Poetry 대비 다운로드 2배.
- `pyproject.toml`: `[tool.poetry]` → PEP 621 `[project]` 포맷
- `fastapi` → `fastapi[standard]` (CLI 실행에 필요한 uvicorn 포함)

---

### worklog-frontend-mock — Node.js 20 → 24

> ⚠️ **강의자 필수 확인 사항**
>
> `sungmincs/worklog-frontend-mock` 저장소의 `Dockerfile` 반영 필요.

- **Before**: `node:20-bookworm-slim` (EOL Apr 2026)
- **After**: `node:24-bookworm-slim`

---

### worklog-mongodb — 버전 및 구성 변경

| 항목 | Before | After | 이유 |
|------|--------|-------|------|
| 이미지 | `mongo:4.4.29-focal` (EOL Feb 2024) | `mongo:8.0` | 2년 이상 보안 업데이트 없음 |
| probe | `exec /usr/bin/mongo --eval` | `tcpSocket: 27017` | mongo CLI 7.0+에서 삭제 |
| strategy | `RollingUpdate` | `Recreate` | mongod.lock으로 인한 PVC 동시 접근 충돌 |

---

### worklog manifests — Gateway API 전환

- **Before**: `kind: Ingress`, `ingressClassName: nginx`
- **After**: `kind: HTTPRoute`, `parentRefs: nginx-gateway`
- **이유**: ch2의 인프라가 NGINX Gateway Fabric으로 전환됨에 따라 manifests도 동일하게 전환.

---

### worklog manifests — image 필드 placeholder 변경

- **Before**: `sungminl/worklog-frontend:buildtest1` (하드코딩)
- **After**: `<dockerhub_username>/worklog-frontend-mock:buildtest1` (placeholder)
- **이유**: 하드코딩 상태로 apply 시 arm64/amd64 arch mismatch → `exec format error`. placeholder는 apply 시 즉시 `ErrImagePull`로 명확한 에러 반환. 학습자가 sed로 본인 username 치환하는 단계가 명확해짐.

---

### ch3/3.2~3.4 GUARDRAIL.md 제거 → prompt-guardrails/ch3/로 대체

- **Before**: 각 서브섹션에 개별 `GUARDRAIL.md` 파일 존재 (`ch3/3.2/GUARDRAIL.md` 등)
- **After**: `prompt-guardrails/ch3/3.2-worklog-download.md` 등 통합 가이드로 대체 (Internal only)
- **이유**: 기존 GUARDRAIL.md는 B방향(파일 제공) 기반 구버전 가이드. A방향 전환과 함께 prompt-guardrails 구조로 재편. 가이드는 Internal에만 존재하고 학습자에게 노출 안 됨.
- **반영 위치**: Public에서 3개 파일 삭제, Internal의 `prompt-guardrails/ch3/` 신규 작성

---

### ch3 가이드 — AI 프롬프트 vs 학습자 직접 입력 분리

- **이유**: `sed`, `vi`, `kubectl edit` 같은 편집 도구 설명이 핵심 학습(docker build, kubectl apply) 흐름을 방해.
- **원칙**: 편집 도구 → AI 프롬프트. 핵심 명령 → 학습자 직접.
- **적용 단계**: ch3.4 단계 4 (image username 치환), 단계 8 (코드 수정), 단계 9 (이미지 태그 업데이트)
