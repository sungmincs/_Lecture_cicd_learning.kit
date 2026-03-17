# GUARDRAIL: 7.4 Argo Rollouts 설치 및 구성

## 범위 (Scope)
### 이 단계에서 다루는 것
- Argo Rollouts 컨트롤러 설치 (argo-rollouts 네임스페이스)
- kubectl argo rollouts 플러그인 설치
- 설치 검증 (버전 확인, Pod 상태 확인)

### 이 단계에서 다루지 않는 것
- Blue-Green 배포 실습 (7.5에서 다룸)
- Canary 배포 실습 (7.6에서 다룸)
- Argo Rollouts Dashboard 설치 (선택사항)

## 사전 조건 (Prerequisites)
- ch6 완료 (Argo CD 설치 및 파이프라인 구성)
- Kubernetes 클러스터 접속 가능 (kubectl 동작 확인)
- 클러스터에 admin 권한 보유

## 순서 (Sequence)
### Step 1: argo-rollouts 네임스페이스 생성
- 명령어: `kubectl create namespace argo-rollouts`
- 기대 결과: namespace/argo-rollouts created

### Step 2: Argo Rollouts 컨트롤러 설치
- 명령어: `kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml`
- 기대 결과: CRD, ServiceAccount, Role, Deployment 등 리소스 생성

### Step 3: kubectl 플러그인 설치
- 명령어: `curl -LO https://github.com/argoproj/argo-rollouts/releases/latest/download/kubectl-argo-rollouts-linux-amd64`
- 명령어: `chmod +x ./kubectl-argo-rollouts-linux-amd64 && mv ./kubectl-argo-rollouts-linux-amd64 /usr/local/bin/kubectl-argo-rollouts`
- 기대 결과: kubectl-argo-rollouts 바이너리가 PATH에 설치됨

### Step 4: 설치 검증
- 명령어: `kubectl argo rollouts version`
- 명령어: `kubectl get pods -n argo-rollouts`
- 기대 결과: 버전 출력, argo-rollouts Pod Running 상태

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| 네임스페이스 | `kubectl get ns argo-rollouts` | Active 상태 |
| 컨트롤러 | `kubectl get pods -n argo-rollouts` | argo-rollouts Pod Running |
| CRD | `kubectl get crd rollouts.argoproj.io` | Rollout CRD 존재 |
| 플러그인 | `kubectl argo rollouts version` | 버전 정보 출력 |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| (없음) | 공식 설치 URL 사용으로 플레이스홀더 없음 | - |

## 주의사항 (Cautions)
- ⛔ 기존 Deployment 리소스와 Rollout 리소스는 별개 — Deployment를 Rollout으로 마이그레이션할 때 기존 Deployment를 먼저 삭제해야 충돌 방지
- ⛔ 플러그인 바이너리 아키텍처(linux-amd64)가 실행 환경과 일치하는지 확인
- ✅ `install_argo_rollouts.sh` 스크립트를 사용하면 전체 설치를 한 번에 수행 가능
- ✅ Argo Rollouts는 Argo CD와 독립적으로 동작하지만, 함께 사용하면 GitOps 기반 고급 배포 가능
