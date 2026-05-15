# ch4 변경 이력

## [2026-05]

### Jenkins `2.440.3` → `2.541.3`

> ⚠️ **강의자 필수 확인 사항**
>
> `sungminl/inbound-agent-docker` 이미지를 새 버전으로 재빌드 필요.

- **Before**: Jenkins `2.440.3-lts-jdk17` (EOL May 2024), chart `5.1.12`
- **After**: Jenkins `2.541.3-lts-jdk17`, chart `5.2.0`
- **이유**: EOL 버전 사용 불가. 2026년 5월 기준 최신 LTS.
- **inbound-agent**: `3248.v65ecb_254c298-3-jdk17` → `3355.v388858a_47b_33-20-jdk17`
- **반영 위치**: `k8s-edu/Lkv1_main/helm-charts/v1.35/cicd/jenkins/` (chart), `ch4/4.5/install_jenkins.sh`

### Jenkins `update-center.json` 스냅샷 갱신

- **Before**: 2.452.1 기준 스냅샷 (2024-05-15, 플러그인 1,954개)
- **After**: 2.541.x 기준 스냅샷 (2026-05-13, 플러그인 2,073개)
- **이유**: 플러그인 버전 고정으로 강의 재현성 확보. 외부 UC가 업데이트되어도 동일 버전 설치.
- **반영 위치**: `ch4/4.5/update-center.json`

### Jenkins `wip` 브랜치 → `main` 브랜치 URL 전환

- **Before**: `sungmin/wip/ch4/4.4.1/` 경로 참조 (임시 브랜치)
- **After**: `main/ch4/4.5/` 경로 참조
- **이유**: wip 브랜치는 임시 작업용. main 브랜치의 영구 경로로 정착.
- **반영 위치**: `ch4/4.5/install_jenkins.sh`, `ch4/4.5/jenkins-config.yaml`

### Jenkins Ingress → HTTPRoute (Gateway API)

- **Before**: `controller.ingress.enabled=true`, `ingressClassName=nginx`, NodePort 32123
- **After**: `serviceType=ClusterIP`, `jenkins-httproute.yaml` 별도 적용
- **이유**: ch2 인프라가 NGINX Gateway Fabric으로 전환됨. Ingress 사용 불가.
- **접근 URL**: `http://jenkins.myk8s.local` (hosts: `192.168.1.99 jenkins.myk8s.local`)
- **반영 위치**: `ch4/4.5/install_jenkins.sh`, `ch4/4.5/jenkins-httproute.yaml` (신규)

### Argo CD `v2.11.0` → `v3.4.2`

- **Before**: Argo CD `v2.11.0` (2.x 전체 EOL), chart `6.9.0`
- **After**: Argo CD `v3.4.2`, chart `9.5.14`
- **이유**: 2.x 시리즈 전체 EOL. 3.x가 현재 지원 라인.
- **반영 위치**: `k8s-edu/Lkv1_main/helm-charts/v1.35/cicd/argo-cd/`
