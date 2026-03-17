# GUARDRAIL: 7.5 Blue-Green 배포 실습

## 범위 (Scope)
### 이 단계에서 다루는 것
- Argo Rollouts의 Rollout 리소스를 사용한 Blue-Green 배포 구성
- Active/Preview 서비스 구성 및 트래픽 전환
- 수동 Promote를 통한 버전 전환 실습
- Rollout 상태 모니터링 (`kubectl argo rollouts get rollout`)

### 이 단계에서 다루지 않는 것
- Canary 배포 (7.6에서 다룸)
- 자동 Promote 설정 (autoPromotionEnabled: true)
- Argo Rollouts Dashboard를 통한 시각적 관리

## 사전 조건 (Prerequisites)
- ch7/7.4 완료 (Argo Rollouts 컨트롤러 및 플러그인 설치)
- Docker Hub에 worklog-backend 이미지가 push된 상태
- 기존 worklog-backend Deployment가 있다면 먼저 삭제 필요

## 순서 (Sequence)
### Step 1: Blue-Green Rollout 리소스 배포
- 명령어: `kubectl apply -f 1.worklog-backend-rollout-bluegreen.yaml`
- 명령어: `kubectl apply -f 2.worklog-backend-services-bluegreen.yaml`
- 기대 결과: Rollout과 Active/Preview 서비스 생성

### Step 2: 초기 배포 상태 확인
- 명령어: `kubectl argo rollouts get rollout worklog-backend --watch`
- 기대 결과: 3개의 Pod가 Running, Active 서비스에 연결

### Step 3: 이미지 업데이트로 Blue-Green 배포 트리거
- 명령어: `kubectl argo rollouts set image worklog-backend worklog-backend=<dockerhub_username>/worklog-backend:<new_tag>`
- 기대 결과: 새 ReplicaSet 생성, Preview 서비스에 연결

### Step 4: Preview 환경 확인 후 Promote
- 명령어: `kubectl argo rollouts promote worklog-backend`
- 기대 결과: Active 서비스가 새 버전으로 전환, 이전 버전 Pod 제거

### Step 5: 최종 검증
- 명령어: `kubectl get pods`, `kubectl get svc`
- 기대 결과: 새 버전 Pod만 Running, Active 서비스 정상

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| Rollout 생성 | `kubectl get rollout worklog-backend` | Rollout 리소스 존재 |
| 서비스 확인 | `kubectl get svc` | active, preview 서비스 모두 존재 |
| Preview 전환 | `kubectl argo rollouts get rollout worklog-backend` | Preview 환경에 새 버전 배포 |
| Promote | `kubectl argo rollouts get rollout worklog-backend` | Active로 전환 완료, Healthy 상태 |
| Pod 확인 | `kubectl get pods` | 새 버전 Pod만 Running |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| `<dockerhub_username>` | Docker Hub 사용자명 | ❌ 반드시 확인 필요 |
| `<new_tag>` | 배포할 새 이미지 태그 | ❌ 반드시 확인 필요 |

## 주의사항 (Cautions)
- ⛔ 기존 Deployment와 Rollout 이름이 동일하면 충돌 — 기존 Deployment를 먼저 `kubectl delete deployment worklog-backend`로 삭제
- ⛔ `<dockerhub_username>`을 임의로 채우지 말 것 — 수강생의 실제 Docker Hub 계정 사용
- ✅ `autoPromotionEnabled: false`로 설정하여 수동 Promote 과정을 직접 체험
- ✅ Preview 서비스로 접속하여 새 버전을 사전 테스트할 수 있음
