# GUARDRAIL: 6.4 Argo CD를 이용하여 서비스 배포하기

## 범위 (Scope)
### 이 단계에서 다루는 것
- Argo CD에 Git 저장소 등록
- Argo CD Application 생성 (CLI 및 YAML manifest)
- 자동 동기화(Automated Sync) 설정
- 배포 상태 확인 (UI, CLI, kubectl)

### 이 단계에서 다루지 않는 것
- 알림 설정 (6.5에서 다룸)
- CI 파이프라인과의 통합 (6.6~6.8에서 다룸)

## 사전 조건 (Prerequisites)
- ch6/6.2 완료 (Argo CD 설치)
- ch6/6.3 완료 (Argo CD CLI 설치 및 로그인)
- GitHub에 worklog-backend_v1 저장소 존재 (deploy_manifest 디렉토리 포함)

## 순서 (Sequence)
### Step 1: Git 저장소 등록
- 명령어: `argocd repo add https://github.com/<github_username>/worklog-backend_v1.git`
- 기대 결과: 저장소 연결 성공

### Step 2: Argo CD Application 생성
- 명령어: `argocd app create worklog-backend --repo ... --path deploy_manifest --dest-server https://kubernetes.default.svc --dest-namespace default --sync-policy automated`
- 또는: `kubectl apply -f 1.worklog-backend-app.yaml`
- 기대 결과: Application 생성 및 자동 동기화 시작

### Step 3: 동기화 확인
- 명령어: `argocd app sync worklog-backend`
- 기대 결과: Application Synced 상태

### Step 4: 배포 결과 확인
- 명령어: `kubectl get pods`, `kubectl get svc`
- 기대 결과: worklog-backend pod Running, service 존재

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| 저장소 등록 | `argocd repo list` | worklog-backend_v1 저장소 표시 |
| Application | `argocd app list` | worklog-backend Synced/Healthy |
| Pod | `kubectl get pods` | worklog-backend pod Running |
| Service | `kubectl get svc` | worklog-backend ClusterIP 서비스 |
| UI | Argo CD 대시보드 확인 | Application 카드에 녹색 Healthy 표시 |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| `<github_username>` | GitHub 사용자명 | ❌ 반드시 수강생에게 확인 필요 |

## 주의사항 (Cautions)
- ⛔ `<github_username>`을 임의로 채우지 말 것 — 수강생의 실제 GitHub 계정 사용
- ⛔ deploy_manifest 디렉토리가 저장소에 존재하는지 먼저 확인
- ✅ CLI와 YAML manifest 두 가지 방법 모두 학습 — 결과는 동일
- ✅ automated sync를 설정하면 Git 변경 시 자동으로 배포됨
