# Changelog

## 버전 변경

| 컴포넌트 | Before | After | 이유 | 반영 위치 | 테스트 |
|----------|--------|-------|------|-----------|--------|
| MongoDB | `4.4.29` | `8.0` | EOL Feb 2024 | `ch3/3.4/worklog_manifests/` (Public) | ✅ K8s 배포 + CRUD |
| Node.js | `20` | `24` | EOL Apr 2026 | `sungmincs/worklog-frontend-mock` | ✅ 빌드 + HTTP 200 |
| Python | `3.12.3` | `3.14` | patch 고정 → 최신 | `sungmincs/worklog-backend` | ✅ 빌드 + /health |
| Poetry | `1.8.0` | 제거 | 2026 기준 uv 대비 다운로드 절반. FastAPI 공식 문서 언급 없음 | `sungmincs/worklog-backend` | — |
| uv | 미사용 | `0.11.14` | 2026 생태계 표준. FastAPI 공식 권장 | `sungmincs/worklog-backend` | ✅ 빌드 + API 응답 |
| React | `^18.2.0` | `^19.0.0` (19.2.6) | 최신 stable (Dec 2024 출시) | `sungmincs/worklog-frontend-mock` | ✅ 빌드 + HTTP 200 + 마운트 확인 |

---

## 주요 구성 변경

| 항목 | Before | After | 이유 | 반영 위치 | 테스트 |
|------|--------|-------|------|-----------|--------|
| K8s 라우팅 | `Ingress` | `HTTPRoute` (Gateway API) | K8s 공식 표준. Ingress deprecated 방향 | `ch2/extra_k8s_pkgs.sh`, `ch3/3.4/worklog_manifests/` (Public) | ✅ K8s 배포 + curl 200 |
| Docker daemon | 기본값 | `{"ipv6": false}` | Vagrant VM — IPv6 라우팅 없어 Docker Hub 연결 실패 | `ch2/2.11/install_docker.sh` (Public) | ✅ docker build 성공 |
| 이미지 필드 | `sungminl/<name>` | `<dockerhub_username>/<name>` | 하드코딩 시 arch mismatch 오류, 학습자 혼동 | `ch3/3.4/worklog_manifests/` (Public) | ✅ K8s 배포 + pods Ready |
| Vite allowedHosts | 미설정 | `[".myk8s.local"]` | Vite 5.4+ Host 헤더 검증 강화 — K8s 배포 시 403 차단 | `sungmincs/worklog-frontend-mock` vite.config.ts | ✅ K8s 배포 + HTTP 200 |
| ch3 가이드 | 모든 단계 직접 입력 | `[AI 프롬프트]` / `[학습자 직접]` 분리 | sed/vi 설명이 핵심 학습 흐름 방해 | `prompt-guardrails/ch3/` (Internal) | ❌ 강의 시나리오 미검증 |

---

## 챕터별 상세

- [ch2 변경 이력](ch2/CHANGELOG.md)
- [ch3 변경 이력](ch3/CHANGELOG.md)

---

## 히스토리

| 날짜 | 변경 |
|------|------|
| 2026-05-14 | Node 24, Python 3.14 + uv, React 19, vite allowedHosts K8s E2E 검증 완료 |
| 2026-05-13 | MongoDB 8.0, Gateway API, placeholder, IPv6 fix 적용 |
| 2026-05-12 | ch3.4 e2e 검증 (Phase 7), SSoT 분리 규칙 수립 |
| 2026-05 | ch2 Gateway API 전환, Docker installer 재배치 |
| 2026-04 | Calico v3.31.2, containerd noble, Ubuntu 24.04 |
