# GUARDRAIL: 6.2 Argo CD 설치 및 구성

> **NOTE:** Argo CD 초기 구성 단계 — 이 도구가 처음으로 설정됨

## 범위 (Scope)
### 이 단계에서 다루는 것
- GitOps 개념 이해
- Argo CD를 K8s 클러스터에 설치
- Argo CD 기본 구성 완료 (namespace, manifest, notification catalog)

### 이 단계에서 다루지 않는 것
- Argo CD로 실제 서비스 배포 (6.4에서 다룸)
- Argo CD 알림 설정 (6.5에서 다룸)
- Argo CD UI 탐색 및 CLI 설치 (6.3에서 다룸)

## 사전 조건 (Prerequisites)
- ch2 완료 (K8s 클러스터 구성 완료)
- ch4 완료 (CI/CD 도구 3종 구성 — GitHub Actions, Jenkins, GitLab)

## 순서 (Sequence)
### Step 1: argocd namespace 생성
- 명령어: `kubectl create namespace argocd`
- 기대 결과: argocd 네임스페이스 생성 (이미 존재하면 무시)

### Step 2: Argo CD manifest 적용
- 명령어: `kubectl apply -n argocd -f ./argocd-manifest.yaml`
- 기대 결과: Argo CD 핵심 컴포넌트(server, repo-server, application-controller 등) 배포

### Step 3: Notification catalog 적용
- 명령어: `kubectl apply -n argocd -f ./argocd-notification-catalog.yaml`
- 기대 결과: 알림 템플릿 및 트리거 ConfigMap 생성

### Step 4: Argo CD 서버 접속 확인
- 명령어: `kubectl get pods -n argocd`
- 기대 결과: 모든 pod가 Running 상태

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| namespace | `kubectl get ns argocd` | argocd 네임스페이스 존재 |
| pods | `kubectl get pods -n argocd` | 모든 pod Running 상태 |
| services | `kubectl get svc -n argocd` | argocd-server 서비스 존재 |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| (없음) | - | - |

## 주의사항 (Cautions)
- ⛔ argocd-manifest.yaml을 인터넷에서 직접 다운받지 말 것 — 학습 키트에 포함된 버전 사용
- ⛔ Argo CD를 설치하기 전에 K8s 클러스터가 정상 동작하는지 반드시 확인
- ✅ install.sh 스크립트를 사용하면 위 단계를 한 번에 실행 가능
- ✅ pod가 모두 Running이 될 때까지 1~2분 대기 필요
