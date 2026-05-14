# ch2 변경 이력

## [2026-05]

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
