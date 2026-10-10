# 강의 고정 버전 (Lecture Fixed Versions)

이 강의가 빌드·녹화·검증에 사용하는 **단일 진실(source of truth)** 버전 세트다.
코드·매니페스트·가드레일 생성 시 이 표의 값을 참조한다.

> 최종 갱신: 2026-08-30 · 검증 기준: run-37(ch2~ch9 완주, 2026-06-16) + ch10 실배포(2026-07-03)
>
> **이 문서는 지금 쓰는 값만 담는다.**

## 🔒 고정 — bump 금지

| 구성요소 | 버전 | 이유 |
|---------|------|------|
| Kubernetes | **1.35.2** | 다른 sysnet4admin 강의(k8s_learning.kit 등)와 일관성 |
| containerd | **2.2.2** | 〃 |
| Debian (이미지 베이스) | **bookworm** | ch9.6 Trivy 게이트 데모 — 의도적 저버전 (결정 기록 2026-06-01) |
| Trivy | **v0.75.0** (액션은 `trivy-action@v0.36.0`) | 본체와 액션은 고정하고 취약점 DB만 실행할 때마다 최신을 받는다(2026-10-10). 갱신 트리거: bookworm LTS 종료(2028-06-30) |

## ⬆️ 애플리케이션·도구 버전 (현재 값 — sysnet4admin/main 기준)

> 첫 컬럼은 **지금 실제 사용 중인 값**. 이전 값·이력은 비고/각 CHANGELOG 참조.

| 구성요소 | 현재 값 | 비고 (이전 → 상태) |
|---------|--------|------|
| Python (backend 베이스) | **3.14-slim-bookworm** | 이전 3.12.3 → 적용(aa49475). `requires-python`은 **>=3.12 유지**(런타임만 3.14). run-10 검증(로컬/GitLab/GitHub Actions green) |
| Node (frontend 베이스) | **24-bookworm-slim** | 이전 20 → 적용(4a91ade). run-10 검증(docker build, node 24.16.0). 교재 통일(84f7785) |
| Node (로컬 설치, ch3.3) | **24** (`setup_24.x`) | 84f7785이 컨테이너만 통일하고 로컬을 빠뜨려 20으로 남아 있던 것을 2026-08-30에 맞춤. 컨테이너와 같은 `yarn install`·`yarn dev`를 돌리므로 같은 메이저를 쓴다 |
| Vite (frontend dev 서버) | **5.3.3** | `package.json: ^5.2.0` → `yarn.lock: 5.3.3` 고정. ⚠️ **5.4+로 올리면 dev 서버 403** → `vite.config server.allowedHosts: [".myk8s.local"]` 필수(c60da5f 반영, 5.3.3에선 무동작·forward-compatible). 5.4+ 전환 시 K8s 브라우저 접속 재검증 |
| uv | **0.11.18** | 이미지 번들은 rolling이지만, 파이프라인이 `curl`로 직접 설치하는 곳은 모두 `https://astral.sh/uv/0.11.18/install.sh`로 고정한다(2026-08-30에 5.5·5.6·ch9, 2026-10-09에 6.8·7.8·7.9·8.5·8.6·10.7 추가. 정답 파일 13곳). 미고정 시 uv가 깨지는 변경을 내면 Jenkins 절 전체가 막힌다 |
| mongo | **8.0** | 이전 7/8.0 혼재 → 통일(a5e084e, ch3.6·7.7·8.2). 최신 stable major |
| docker (CI 이미지) | **24** (+24-dind) | 통일 완료(이슈 #48). docker:27 사용 금지 |
| Argo Rollouts | **v1.9.0** | 이미 최신 |
| **Argo CD** | **v3.4.3** | 강의 install manifest를 v3.4.3로 교체(공식 install.yaml + server.insecure/TZ 커스터마이징). ✅ run-12 클린 설치 검증 완료(`argocd: v3.4.3+1801122`), run-33~37 재확인. |
| Argo CD CLI | **v3.4.3** | 서버와 같은 버전. 노드 설치(6.4)와 파이프라인 안 설치(6.8, 10.6) 모두 `releases/download/v3.4.3/`로 고정(2026-10-09). `releases/latest`를 쓰지 않는다 |

## 호스트 설치 도구 (학습자 PC)

| 구성요소 | 버전 | 위치 |
|---------|------|------|
| VirtualBox | v7.0.18 | `ch2/2.3/virtualbox-v7.0.18/` |
| Vagrant | v2.4.1 | `ch2/2.3/vagrant-v2.4.1/` |
| VirtualBox (2.4, arm64) | v7.1.10 | `ch2/2.4/virtualbox-v7.1.10/` |
| Vagrant (2.4, arm64) | v2.4.7 | `ch2/2.4/vagrant-v2.4.7/` |
| Tabby | v1.0.207 | `ch2/2.3/tabby-v1.0.207/`, `ch2/2.4/` |

> VirtualBox와 Vagrant는 짝이다. 한쪽만 올리면 `vagrant up`이 실패한다.
> 버전이 디렉터리 이름이라 올릴 때 디렉터리를 새로 만든다.

## 클러스터 애드온 (`extra_k8s_pkgs.sh`가 자동 설치)

**⚠️ 이 파일들은 이 저장소가 아니라 `sysnet4admin/IaC`의 `k8s/extra-pkgs/v1.35/`에 있다.**

| 구성요소 | 버전 | 파일 |
|---------|------|------|
| Helm | v4.0.4 | `get_helm_v4.0.4.sh` |
| MetalLB | v0.15.3 | `metallb-native-v0.15.3.yaml` (+ l2mode, iprange) |
| metrics-server | v0.8.0 | `metrics-server-notls-v0.8.0.yaml` |
| CSI Driver NFS | v4.12.1 | `csi-driver-nfs-v4.12.1.yaml` |
| NGINX Gateway Fabric | v2.3.0 | `nginx-gateway-loadbalancer-v2.3.0.yaml` |

Jenkins helm 차트도 같은 방식이다: `k8s-edu/Lkv1_main`의 `helm-charts/v1.35/cicd/`.
경로의 `v1.35`가 쿠버네티스 버전이며 주로 5단계마다 올린다(다음 **v1.40**).

## ch9 게이트 도구

| 구성요소 | 고정 방식 | 비고 |
|---------|----------|------|
| ruff | `uv.lock` (현재 0.15.13) | `pyproject.toml`의 `>=0.4.4`는 하한일 뿐. `uv run`이 락을 쓴다 |
| pip-audit | `uv.lock` (dev 의존성 `>=2.7.0`) | ⛔ **`uvx pip-audit`을 쓰지 않는다.** 격리 환경에서 돌아 프로젝트 의존성을 못 본다 → 항상 "취약점 없음". `uv run`으로 교체(2026-08-30) |
| coverage | `uv.lock` (`>=7.5.1`) | |
| **Trivy** | **v0.75.0**, GitHub는 `aquasecurity/trivy-action@v0.36.0` | 본체와 액션은 고정. CVE DB는 실행 때마다 최신이라 결과는 날짜에 따라 달라진다. Jenkins는 `v0.75.0` 태그의 설치 스크립트로 받는다 |
| gitleaks | **8.30.1** (Jenkins) / `gitleaks-action@v2` (GitHub) | 2026-08-30에 Jenkins 정답 파일에 추가(GitLab 판은 2026-10-04 구조 변경으로 제거). 자산 이름이 `gitleaks_<버전>_linux_<x64\|arm64>.tar.gz`라 `uname -m`으로 분기한다 |

## 인프라 고정값 (검증 완료, 현재 최신)

| 구성요소 | 버전 |
|---------|------|
| Docker 엔진 (노드) | 29.3.1 |
| NGINX Gateway Fabric | v2.3.0 (Gateway API v1.4.1) |
| Jenkins | 2.541.3 (edu helm `v1.35/cicd`) |
| Argo CD | v3.4.3 (run-12 검증 완료) |
| Argo Rollouts | v1.9.0 |

## ch10 클라우드 스택 (실배포 검증 2026-07-03, 2026-10-04, run-40 2026-10-10)

| 구성요소 | 값 | 비고 |
|---------|------|------|
| EKS `cluster_version` | **1.36** | 1.29는 EKS 생성 불가. 노드 v1.36.4-eks 확인(2026-10-10) |
| terraform-aws-modules/eks | **~> 20.0** | v21 금지: provider `>= 6.0` 강제 + node group count 버그 → VPC 모듈 연쇄. `enable_cluster_creator_admin_permissions = true` 필수. `node_security_group_additional_rules`의 `ingress_self_all`도 필수(기본 규칙은 노드 사이에 1025 이상 포트만 열어 backend 80번이 막힌다, run-40) |
| terraform-aws-modules/vpc | ~> 5.0 | provider `< 6.0` 유지용 |
| provider aws | ~> 5.0 | 〃 |
| Terraform CLI | **1.15.7** | 노드에 HashiCorp apt 저장소로 설치(`terraform=1.15.7-1`). 10.10 파이프라인 이미지(`hashicorp/terraform:1.15.7`)와 같은 값 |
| AWS CLI v2 | **2.35.17** | 노드에 버전이 붙은 zip으로 설치(10.3 단계 3). Jenkins 에이전트 이미지도 같은 버전(10.7 단계 1) |
| kubectl (Jenkins 에이전트 이미지) | v1.36.0 | EKS 1.36에 맞춤(10.7 단계 1) |
| Jenkins 에이전트 이미지(10.7) | 베이스 `sungminl/inbound-agent-docker:3248.v65ecb_254c298-3-jdk17`, 학습자가 `<dockerhub_username>/inbound-agent-docker:eks`로 빌드 | aws, kubectl, argocd를 더한다. 로컬 ConfigMap에 보이는 `jenkins/inbound-agent`는 쓰이지 않는 차트 기본값이다 |
| EKS 노드 | **c7i-flex.large** × 3 (min2/max4) | 무료 플랜은 무료 등급 대상만 실행(t3.medium 거부). 2026-10-04 실검증 |
| 서비스 계정 권한 | **EKS Pod Identity** (`eks-pod-identity-agent`), `enable_irsa = false` | 새 가입 방식 SCP가 OIDC provider 생성 거부(IRSA 불가). 2026-10-04 실검증 |
| AWS Load Balancer Controller | **v3.6.0** (helm `eks/aws-load-balancer-controller --version 3.6.0`, IAM 정책 문서도 v3.6.0) | Pod Identity로 설치. 차트 버전을 고정하지 않으면 최신이 깔린다(run-39에서 정책 v3.5.0에 컨트롤러 v3.6.0) |
| 리전 | aws configure 한 곳 (파일에 적지 않음) | 기존 계정 ap-northeast-2, 새 가입 방식(한국) ap-southeast-2 |
| 외부 노출 | **AWS Load Balancer Controller + ALB Ingress** | ingress-nginx·HTTPRoute 사용 안 함 (NGF는 로컬 전용) |
| Argo CD (EKS) | v3.4.3 | ch6.3 매니페스트(공식 stable install 아님), LoadBalancer 노출, `argocd login --plaintext` |

## sungmincs 정본 저장소 상태

학습자가 fork하는 정본.

| 저장소 | 상태 (2026-10-10) |
|--------|------|
| `sungmincs/worklog-backend` | `main`을 fork해 4장부터 쓴다 |
| `sungmincs/worklog-frontend` | 저장소 하나에 브랜치 둘. `mock`은 3장(가짜 데이터, backend 없이 화면이 나온다), `main`은 7장부터(backend와 실제로 주고받는다). `main`에 Dockerfile과 `vite.config.ts`의 `allowedHosts`가 들어 있다(2026-10-10) |
| `sungmincs/worklog-frontend-mock` | 쓰지 않는다. 내용은 위 저장소의 `mock` 브랜치로 옮겼다 |

> **원칙**: fork 원본에는 교육 과정 중 학습자가 꼭 직접 만들어야 하는 파일을 두지 않는다.
> 정답 파일은 `chN/N.M/`에 있고 가드레일이 그것을 가리킨다.
