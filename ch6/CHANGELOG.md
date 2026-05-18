# ch6 변경 이력

## [2026-05]

### ch6.2 Argo CD — Ingress → HTTPRoute (Gateway API) 전환

- **Before**: `argocd-manifest.yaml`의 `kind: Ingress`, `ingressClassName: nginx`
- **After**: `argocd-httproute.yaml` — HTTPRoute + ReferenceGrant
- **이유**: ch2 인프라가 NGINX Gateway Fabric으로 전환됨. nginx Ingress Controller 없어서 Ingress가 동작 안 함.

**추가된 파일: `ch6/6.2/argocd-httproute.yaml`**
- `HTTPRoute` (default ns) → `argocd-server` (argocd ns)
- `ReferenceGrant` (argocd ns) — cross-namespace 참조 허용

**`install.sh` 변경:**
- Ingress 삭제 후 HTTPRoute 자동 적용
- 접근 URL: `http://argocd.myk8s.local` (hosts: `192.168.1.99 argocd.myk8s.local`)

### ch6.3 hosts 파일 설정

- **Before**: `192.168.1.99 argocd.myk8s.local` (기존 Ingress Controller IP)
- **After**: 동일 (`192.168.1.99`) — NGF가 `.99`로 고정되어 그대로 유지
