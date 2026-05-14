# ch3 변경 이력

## [2026-05]

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

### ch3 가이드 — AI 프롬프트 vs 학습자 직접 입력 분리

- **이유**: `sed`, `vi`, `kubectl edit` 같은 편집 도구 설명이 핵심 학습(docker build, kubectl apply) 흐름을 방해.
- **원칙**: 편집 도구 → AI 프롬프트. 핵심 명령 → 학습자 직접.
- **적용 단계**: ch3.4 단계 4 (image username 치환), 단계 8 (코드 수정), 단계 9 (이미지 태그 업데이트)
