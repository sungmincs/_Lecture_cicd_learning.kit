# Changelog

## 버전 변경

| 컴포넌트 | Before | After | 이유 | 반영 위치 | 테스트 |
|----------|--------|-------|------|-----------|--------|
| MongoDB | `4.4.29` | `8.0` | EOL Feb 2024 | `ch3/3.4/worklog_manifests/` (Public) | ✅ K8s 배포 + CRUD |
| Node.js | `20` | `24` | EOL Apr 2026 | `sungmincs/worklog-frontend-mock` | ✅ 빌드 + HTTP 200 |
| Python | `3.12.3` | `3.14` | patch 고정 → 최신 | `sungmincs/worklog-backend` | ✅ 빌드 + /health |
| Poetry | `1.8.0` | 제거 | 2026 기준 uv 대비 다운로드 절반. FastAPI 공식 문서 언급 없음 | `sungmincs/worklog-backend` | — |
| uv | 미사용 | `0.11.14` | 2026 생태계 표준. FastAPI 공식 권장 | `sungmincs/worklog-backend` | ✅ 빌드 + API 응답 |
| React | `^18.2.0` | `^19.0.0` | 최신 stable (Dec 2024 출시) | `sungmincs/worklog-frontend-mock` | ❌ 검증 예정 |

---

## 주요 구성 변경

| 항목 | Before | After | 이유 | 반영 위치 | 테스트 |
|------|--------|-------|------|-----------|--------|
| K8s 라우팅 | `Ingress` | `HTTPRoute` (Gateway API) | K8s 공식 표준. Ingress deprecated 방향 | `ch2/extra_k8s_pkgs.sh`, `ch3/3.4/worklog_manifests/` (Public) | ✅ K8s 배포 + curl 200 |
| Docker daemon | 기본값 | `{"ipv6": false}` | Vagrant VM — IPv6 라우팅 없어 Docker Hub 연결 실패 | `ch2/2.11/install_docker.sh` (Public) | ✅ docker build 성공 |
| 이미지 필드 | `sungminl/<name>` | `<dockerhub_username>/<name>` | 하드코딩 시 arch mismatch 오류, 학습자 혼동 | `ch3/3.4/worklog_manifests/` (Public) | ✅ K8s 배포 + pods Ready |
| ch3 가이드 | 모든 단계 직접 입력 | `[AI 프롬프트]` / `[학습자 직접]` 분리 | sed/vi 설명이 핵심 학습 흐름 방해 | `prompt-guardrails/ch3/` (Internal) | ❌ 강의 시나리오 미검증 |

---

## 상세

### MongoDB `4.4.29-focal` → `8.0`
**이유**: EOL Feb 2024. 2년 이상 보안 업데이트 없음.

**함께 변경된 것:**
- probe `exec /usr/bin/mongo --eval` → `tcpSocket: 27017`
  - MongoDB 7.0+에서 `mongo` CLI 삭제됨. tcpSocket은 버전에 무관하게 작동
- Deployment strategy `RollingUpdate` → `Recreate`
  - `mongod.lock`으로 `/data/db` 배타적 잠금. RollingUpdate 시 기존 Pod 종료 전 신규 Pod이 같은 PVC에 접근해 충돌 → Recreate 필수

---

### Node.js `20` → `24`
**이유**: Node.js 20 EOL Apr 2026. 강의 개발 시점에 이미 만료.

- `node:20` → `node:24`
- 검증: Vite 5.3, React 18.x, TypeScript 5.4 모두 Node 24 호환 확인

---

### Python `3.12.3` → `3.14` + Poetry → uv

**이유 (Python)**: `3.12.3`은 고정 patch라 최신 보안 fix 미적용. 3.14(EOL Oct 2030)로 올리며 더 긴 지원 확보.

**이유 (uv)**: 2026년 기준 uv 월간 다운로드 1.56억 vs Poetry 0.78억. FastAPI 공식 문서가 uv 섹션 별도 추가. Poetry는 유지보수 모드 전환 중.

변경 내용:
- Dockerfile base image: `python:3.12.3` → `python:3.14`
- 패키지 관리: `pip install poetry==1.8.0 && poetry export` → `uv pip compile && uv pip install`
- `pyproject.toml`: `[tool.poetry]` → PEP 621 `[project]` (표준)
- `fastapi` → `fastapi[standard]` (CLI 실행에 uvicorn 등 포함)
- build-system: `poetry-core` → `hatchling`

---

### Ingress → HTTPRoute (Gateway API)
**이유**: Gateway API가 K8s 공식 표준으로 자리잡음. Ingress는 deprecated 방향.

- `ch2/extra_k8s_pkgs.sh`: NGINX Ingress Controller → NGINX Gateway Fabric v2.3.0
- `ch3/3.4/worklog_manifests/worklog-backend.yaml`: `kind: Ingress` → `kind: HTTPRoute`
- `ch3/3.4/worklog_manifests/worklog-frontend.yaml`: 동일

---

### Docker daemon IPv6 비활성화
**이유**: Vagrant VM에 IPv6 라우팅 없음. Docker Hub 연결 시 IPv6 주소를 먼저 시도 → "no route to host". 학습자가 `--pull=false` 같은 옵션 없이 `docker build`를 그대로 쓸 수 있도록.

`ch2/2.11/install_docker.sh`에 추가:
```json
{ "ipv6": false }
```

---

### 이미지 필드 → `<dockerhub_username>` placeholder
**이유**: `sungminl/`로 하드코딩 시 sed를 건너뛰고 apply하면 amd64/arm64 arch mismatch → `exec format error`. placeholder는 apply 시 즉시 `ErrImagePull`로 명확한 에러 반환.

- `worklog-frontend`: `sungminl/worklog-frontend:` → `<dockerhub_username>/worklog-frontend-mock:` (-mock suffix 포함)
- `worklog-backend`: `sungminl/worklog-backend:` → `<dockerhub_username>/worklog-backend:`

---

### ch3 가이드 — AI 프롬프트 vs 학습자 직접 입력 분리
**이유**: `sed`, `vi`, `kubectl edit` 문법 설명이 docker build/kubectl apply 같은 핵심 학습 흐름을 방해.

원칙:
- 편집 도구 (sed, vi, kubectl edit, yaml 필드 수정) → `[AI 프롬프트]`
- 핵심 명령 (docker build, docker push, kubectl apply, docker login) → `[학습자 직접]`

---

## 히스토리

| 날짜 | 변경 |
|------|------|
| 2026-05-14 | Node 24, Python 3.14 + uv 검증 완료 |
| 2026-05-13 | MongoDB 8.0, Gateway API, placeholder, IPv6 fix 적용 |
| 2026-05-12 | ch3.4 e2e 검증 (Phase 7), SSoT 분리 규칙 수립 |
| 2026-05 | ch2 Gateway API 전환, Docker installer 재배치 |
| 2026-04 | Calico v3.31.2, containerd noble, Ubuntu 24.04 |
