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
| Jenkins | `2.440.3` | `2.541.3` | EOL May 2024 | `k8s-edu/Lkv1_main` chart, `ch4/4.5/` | ✅ HTTP 200 + X-Jenkins: 2.541.3 |
| Jenkins chart | `5.1.12` | `5.2.0` | Jenkins 버전 업 | `k8s-edu/Lkv1_main/helm-charts/v1.35/cicd/` | ✅ |
| inbound-agent | `3248.v65ecb_254c298-3` | `3355.v388858a_47b_33-20` | Jenkins 버전 업 | `ch4/4.5/jenkins-config.yaml` | ✅ |
| Argo CD | `v2.11.0` | `v3.4.2` | 2.x 전체 EOL | `k8s-edu/Lkv1_main` chart | ✅ HTTP 200 확인 |
| Argo CD chart | `6.9.0` | `9.5.14` | Argo CD v3 대응 | `k8s-edu/Lkv1_main/helm-charts/v1.35/cicd/` | ✅ |

---

## 주요 구성 변경

| 항목 | Before | After | 이유 | 반영 위치 | 테스트 |
|------|--------|-------|------|-----------|--------|
| K8s 라우팅 | `Ingress` | `HTTPRoute` (Gateway API) | K8s 공식 표준. Ingress deprecated 방향 | `ch2/extra_k8s_pkgs.sh`, `ch3/3.4/worklog_manifests/` (Public) | ✅ K8s 배포 + curl 200 |
| Docker daemon | 기본값 | `{"ipv6": false}` | Vagrant VM — IPv6 라우팅 없어 Docker Hub 연결 실패 | `ch2/2.11/install_docker.sh` (Public) | ✅ docker build 성공 |
| 이미지 필드 | `sungminl/<name>` | `<dockerhub_username>/<name>` | 하드코딩 시 arch mismatch 오류, 학습자 혼동 | `ch3/3.4/worklog_manifests/` (Public) | ✅ K8s 배포 + pods Ready |
| Vite allowedHosts | 미설정 | `[".myk8s.local"]` | Vite 5.4+ Host 헤더 검증 강화 — K8s 배포 시 403 차단 | `sungmincs/worklog-frontend-mock` vite.config.ts | ✅ K8s 배포 + HTTP 200 |
| ch3 가이드 | 모든 단계 직접 입력 | `[AI 프롬프트]` / `[학습자 직접]` 분리 | sed/vi 설명이 핵심 학습 흐름 방해 | `prompt-guardrails/ch3/` (Internal) | ❌ 강의 시나리오 미검증 |
| NGF LB IP | 동적 (`.11` 자동할당) | `192.168.1.99` 고정 | 강의 가이드 전체 `.99` 사용 — 동적 할당 시 불일치 발생 | `ch2/2.4/controlplane_node.sh` (Public) | ✅ vagrant up 후 자동 .99 할당 확인 |
| Jenkins 접근 | Ingress + NodePort | HTTPRoute (`jenkins.myk8s.local`) | Gateway API 전환으로 Ingress 불가 | `ch4/4.5/jenkins-httproute.yaml` (신규, Public) | ✅ HTTP 200 확인 |
| Jenkins update-center | 2.452.1 스냅샷 (2024-05-15) | 2.541.x 스냅샷 (2026-05-13) | EOL 버전 플러그인 목록 갱신 | `ch4/4.5/update-center.json` (Public) | ✅ Jenkins 2.541.3 설치 확인 |
| Argo CD 접근 | Ingress (`ingressClassName: nginx`) | HTTPRoute + ReferenceGrant | Gateway API 전환으로 Ingress 불가 | `ch6/6.2/argocd-httproute.yaml` (신규, Public) | ✅ HTTP 200 확인 |

---

## 챕터별 상세

- [ch2 변경 이력](ch2/CHANGELOG.md)
- [ch3 변경 이력](ch3/CHANGELOG.md)
- [ch4 변경 이력](ch4/CHANGELOG.md)
- [ch6 변경 이력](ch6/CHANGELOG.md)

---

## 히스토리

| 날짜 | 변경 |
|------|------|
| 2026-05-14 | Node 24, Python 3.14 + uv, React 19, vite allowedHosts K8s E2E 검증 완료 |
| 2026-05-13 | MongoDB 8.0, Gateway API, placeholder, IPv6 fix 적용 |
| 2026-05-12 | ch3.4 e2e 검증 (Phase 7), SSoT 분리 규칙 수립 |
| 2026-05 | ch2 Gateway API 전환, Docker installer 재배치 |
| 2026-04 | Calico v3.31.2, containerd noble, Ubuntu 24.04 |
