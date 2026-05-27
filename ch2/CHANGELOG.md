# ch2 변경 이력

## [2026-05]

### 2.3/2.4 .cmd + GUARDRAIL.md — vagrant up 및 클러스터 검증 추가 [2026-05-28]

- **Before**: .cmd가 VirtualBox/Vagrant/Tabby 설치만 다루고 `vagrant up` 미포함. GUARDRAIL "다루지 않는 것: Vagrant VM 생성/실행"으로 잘못 명시
- **After**: `vagrant up` + 클러스터 검증 (노드, NGINX Gateway Fabric, MetalLB, LB IP) 단계 추가
- **GUARDRAIL 범위 수정**: vagrant up + NGINX Gateway Fabric 포함으로 정정. "자동 설치 구성 요소" 섹션 신규 추가
- **HTTPRoute 경고 추가**: ingress-nginx가 아닌 NGINX Gateway Fabric 사용임을 명시 (AI 오안내 방지)
- **이유**: Gateway Fabric 전환이 scripts에만 반영되고 학습자 가이드(.cmd/GUARDRAIL)에는 미반영 상태였음

---

### extra_k8s_pkgs.sh — K8s 라우팅 전환
- **Before**: NGINX Ingress Controller
- **After**: NGINX Gateway Fabric v2.3.0 (Gateway API)
- **이유**: K8s Gateway API가 공식 표준으로 자리잡음. Ingress는 deprecated 방향. HTTPRoute 기반으로 전환.

### install_docker.sh 위치 이동
- **Before**: `ch3/3.2/install_docker.sh`
- **After**: `ch2/2.11/install_docker.sh`
- **이유**: Docker 설치는 ch3 실습 전에 완료돼야 하는 사전 조건. 학습 흐름 재구성.

### install_docker.sh — Docker daemon IPv6 비활성화 추가
- **Before**: Docker 설치만
- **After**: 설치 후 `/etc/docker/daemon.json` → `{"ipv6": false}` 적용
- **이유**: Vagrant VM 환경에서 Docker Hub 연결 시 IPv6 주소로 시도 → "no route to host" 오류 발생. 학습자가 `docker build` 시 별도 옵션 없이 사용 가능하도록.

### controlplane_node.sh — namespace 오류 수정

- **Before**: `kubectl annotate svc nginx-gateway-nginx -n nginx-gateway ...`
- **After**: `kubectl annotate svc nginx-gateway-nginx -n default ...`
- **이유**: `nginx-gateway-nginx` LoadBalancer 서비스는 `default` namespace에 있음. `-n nginx-gateway`로 잘못 지정해서 annotation이 적용 안 됐고 .99 자동 할당이 작동하지 않았음.
- **발견 방법**: vagrant up 후 IP가 .99가 아닌 .11로 할당되어 추적

---

### controlplane_node.sh — NGF LB IP `192.168.1.99` 고정
- **Before**: MetalLB 동적 할당 (pool 첫 번째 IP `192.168.1.11` 자동 할당)
- **After**: sleep 700s 후 MetalLB annotation으로 `192.168.1.99` 고정
- **이유**: 강의 가이드(ch3, ch4, ch6) 전체가 `192.168.1.99`를 사용. 동적 할당 시 vagrant up 순서에 따라 IP가 달라져 hosts 파일 설정이 틀릴 수 있음.
- **방식**: `kubectl annotate svc nginx-gateway-nginx -n nginx-gateway metallb.universe.tf/loadBalancerIPs="192.168.1.99"`
