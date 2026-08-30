# 강의 고정 버전 (Lecture Fixed Versions)

이 강의가 빌드·녹화·검증에 사용하는 **단일 진실(source of truth)** 버전 세트다.
코드·매니페스트·가드레일 생성 시 이 표의 값을 참조한다. 변경 이력은 각 `ch*/CHANGELOG.md`,
변경 근거는 `_INTERNAL_NOTES/decisions.md`에 기록한다.

> 최종 갱신: 2026-08-30 · 검증 기준: run-37(ch2~ch9 완주, 2026-06-16) + ch10 실배포(2026-07-03)
>
> **이 문서는 지금 쓰는 값만 담는다.** 강의 전 최신화 여부와 변경 시 고쳐야 할 곳은
> [[../../_prepublish_updates/README.md]]에 있다.

## 🔒 고정 — bump 금지

| 구성요소 | 버전 | 이유 |
|---------|------|------|
| Kubernetes | **1.35.2** | 다른 sysnet4admin 강의(k8s_learning.kit 등)와 일관성 |
| containerd | **2.2.2** | 〃 |
| Debian (이미지 베이스) | **bookworm** | ch9.6 Trivy 게이트 데모 — 의도적 저버전 ([[../../_INTERNAL_NOTES/decisions.md]] 2026-06-01) |
| Trivy | **:latest** | 취약점 DB가 최신이어야 데모 의미. 갱신 트리거: bookworm LTS 종료(2028-06-30) |

## ⬆️ 애플리케이션·도구 버전 (현재 값 — sysnet4admin/main 기준)

> 첫 컬럼은 **지금 실제 사용 중인 값**. 이전 값·이력은 비고/각 CHANGELOG 참조.

| 구성요소 | 현재 값 | 비고 (이전 → 상태) |
|---------|--------|------|
| Python (backend 베이스) | **3.14-slim-bookworm** | 이전 3.12.3 → 적용(aa49475). `requires-python`은 **>=3.12 유지**(런타임만 3.14). run-10 검증(로컬/GitLab/GitHub Actions green) |
| Node (frontend 베이스) | **24-bookworm-slim** | 이전 20 → 적용(4a91ade). run-10 검증(docker build, node 24.16.0). 교재 통일(84f7785) |
| Node (로컬 설치, ch3.3) | **24** (`setup_24.x`) | 84f7785이 컨테이너만 통일하고 로컬을 빠뜨려 20으로 남아 있던 것을 2026-08-30에 맞춤. 컨테이너와 같은 `yarn install`·`yarn dev`를 돌리므로 같은 메이저를 쓴다 |
| Vite (frontend dev 서버) | **5.3.3** | `package.json: ^5.2.0` → `yarn.lock: 5.3.3` 고정. ⚠️ **5.4+로 올리면 dev 서버 403** → `vite.config server.allowedHosts: [".myk8s.local"]` 필수(c60da5f 반영, 5.3.3에선 무동작·forward-compatible). 5.4+ 전환 시 K8s 브라우저 접속 재검증 |
| uv | **0.11.18** | 이미지 번들은 rolling이지만, Jenkins가 `curl`로 직접 설치하는 9곳은 `https://astral.sh/uv/0.11.18/install.sh`로 고정(2026-08-30). 미고정 시 uv가 깨지는 변경을 내면 ch5.5·5.6·ch9 전체가 막힌다 |
| mongo | **8.0** | 이전 7/8.0 혼재 → 통일(a5e084e, ch3.6·7.7·8.2). 최신 stable major |
| docker (CI 이미지) | **24** (+24-dind) | 통일 완료(이슈 #48). docker:27 사용 금지 |
| Argo Rollouts | **v1.9.0** | 이미 최신 |
| **Argo CD** | **v3.4.3** | 강의 install manifest를 v3.4.3로 교체(공식 install.yaml + server.insecure/TZ 커스터마이징). ✅ run-12 클린 설치 검증 완료(`test-scenarios/run-12/raw/20-ch6.2-argocd-install.md` → `argocd: v3.4.3+1801122`), run-33~37 재확인. 업그레이드 함정은 [[../../_prepublish_updates/argocd.md]] |

## 호스트 설치 도구 (학습자 PC)

| 구성요소 | 버전 | 위치 |
|---------|------|------|
| VirtualBox | v7.0.18 | `ch2/2.3/virtualbox-v7.0.18/` |
| Vagrant | v2.4.1 | `ch2/2.3/vagrant-v2.4.1/` |
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
자세한 절차는 [[../../_prepublish_updates/cluster-addons.md]].

## ch9 게이트 도구

| 구성요소 | 고정 방식 | 비고 |
|---------|----------|------|
| ruff | `uv.lock` (현재 0.15.13) | `pyproject.toml`의 `>=0.4.4`는 하한일 뿐. `uv run`이 락을 쓴다 |
| pip-audit | `uv.lock` (dev 의존성 `>=2.7.0`) | ⛔ **`uvx pip-audit`을 쓰지 않는다.** 격리 환경에서 돌아 프로젝트 의존성을 못 본다 → 항상 "취약점 없음". `uv run`으로 교체(2026-08-30) |
| coverage | `uv.lock` (`>=7.5.1`) | |
| **Trivy** | **:latest (의도적)** | CVE DB가 최신이어야 데모가 성립. 갱신 트리거: bookworm LTS 종료(2028-06-30) |
| gitleaks | **8.30.1** (Jenkins·GitLab) / `gitleaks-action@v2` (GitHub) | 2026-08-30에 Jenkins·GitLab 정답 파일에 추가. 자산 이름이 `gitleaks_<버전>_linux_<x64\|arm64>.tar.gz`라 `uname -m`으로 분기한다 |

## 인프라 고정값 (검증 완료, 현재 최신)

| 구성요소 | 버전 |
|---------|------|
| Docker 엔진 (노드) | 29.3.1 |
| NGINX Gateway Fabric | v2.3.0 (Gateway API v1.4.1) |
| Jenkins | 2.541.3 (edu helm `v1.35/cicd`) |
| Argo CD | v3.4.3 (run-12 검증 완료) |
| Argo Rollouts | v1.9.0 |

## ch10 클라우드 스택 (실배포 검증 2026-07-03)

| 구성요소 | 값 | 비고 |
|---------|------|------|
| EKS `cluster_version` | **1.36** | 1.29는 EKS 생성 불가. 노드 v1.36.2-eks 확인 |
| terraform-aws-modules/eks | **~> 20.0** | v21 금지: provider `>= 6.0` 강제 + node group count 버그 → VPC 모듈 연쇄. `enable_cluster_creator_admin_permissions = true` 필수 |
| terraform-aws-modules/vpc | ~> 5.0 | provider `< 6.0` 유지용 |
| provider aws | ~> 5.0 | 〃 |
| Terraform CLI | 1.15.x | 호스트 brew 설치 기준 |
| EKS 노드 | t3.medium × 3 (min2/max4) | 학습 비용 기준 |
| 외부 노출 | **AWS Load Balancer Controller + ALB Ingress** | ingress-nginx·HTTPRoute 사용 안 함 (NGF는 로컬 전용) |
| Argo CD (EKS) | v3.4.3 | 로컬과 동일 버전, LoadBalancer 노출 |

## sungmincs 정본 저장소 상태

학습자가 fork하는 정본. **현황과 처리 방침은 [[../../_prepublish_updates/fork-repos.md]]에 있다.**

| 저장소 | 상태 (2026-08-30) |
|--------|------|
| `sungmincs/worklog-backend` | PR [#3](https://github.com/sungmincs/worklog-backend/pull/3) 머지됨(2026-06-15). ⚠️ 그 결과 `main`·`develop`에 ch4 실습 결과물이 들어감 |
| `sungmincs/worklog-frontend-mock` | PR [#2](https://github.com/sungmincs/worklog-frontend-mock/pull/2) **OPEN**, 91커밋. ⚠️ 필요한 것(Dockerfile·vite.config.ts)과 실습 결과물이 섞여 있어 전체 머지 불가 |

> **원칙**: fork 원본에는 교육 과정 중 학습자가 꼭 직접 만들어야 하는 파일을 두지 않는다.
> 정답 파일은 `chN/N.M/`에 있고 가드레일이 그것을 가리킨다.
