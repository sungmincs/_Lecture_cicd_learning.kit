# GUARDRAIL: 7.6 Canary 배포 실습

## 범위 (Scope)
### 이 단계에서 다루는 것
- Argo Rollouts의 Canary 전략을 사용한 점진적 배포 구성
- 가중치 기반 트래픽 이동 (20% → 40% → 60% → 80% → 100%)
- 수동 Pause/Promote를 통한 단계별 배포 제어
- Canary 배포 상태 모니터링

### 이 단계에서 다루지 않는 것
- AnalysisTemplate을 활용한 자동 Canary 분석
- Istio/Nginx Ingress 기반 트래픽 분할
- A/B Testing 구현

## 사전 조건 (Prerequisites)
- ch7/7.4 완료 (Argo Rollouts 설치)
- ch7/7.5 완료 (Blue-Green 실습) — 7.5의 리소스를 정리해야 함
- Docker Hub에 worklog-backend 이미지가 2개 이상의 태그로 존재

## 순서 (Sequence)
### Step 1: Blue-Green 리소스 정리
- 명령어: `kubectl delete rollout worklog-backend`
- 명령어: `kubectl delete svc worklog-backend-active worklog-backend-preview`
- 기대 결과: 이전 Blue-Green 리소스 삭제 완료

### Step 2: Canary Rollout 배포
- 명령어: `kubectl apply -f 1.worklog-backend-rollout-canary.yaml`
- 명령어: `kubectl apply -f 2.worklog-backend-service-canary.yaml`
- 기대 결과: Canary 전략의 Rollout과 서비스 생성

### Step 3: 이미지 업데이트로 Canary 배포 트리거
- 명령어: `kubectl argo rollouts set image worklog-backend worklog-backend=<dockerhub_username>/worklog-backend:<new_tag>`
- 기대 결과: Canary Pod 생성, 첫 번째 단계(20%)에서 일시 중지

### Step 4: Canary 단계 진행
- 명령어: `kubectl argo rollouts promote worklog-backend`
- 기대 결과: 다음 가중치 단계로 이동, 30초마다 자동 진행

### Step 5: 최종 검증
- 명령어: `kubectl get pods`
- 기대 결과: 모든 Pod가 새 버전으로 전환 완료

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| 리소스 정리 | `kubectl get rollout`, `kubectl get svc` | Blue-Green 리소스 없음 |
| Canary 생성 | `kubectl get rollout worklog-backend` | Canary 전략 Rollout 존재 |
| 트래픽 분할 | `kubectl argo rollouts get rollout worklog-backend` | 가중치 단계별 진행 확인 |
| Promote | `kubectl argo rollouts get rollout worklog-backend` | 100% 전환 완료, Healthy |
| Pod 확인 | `kubectl get pods` | 5개 Pod 모두 새 버전 Running |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| `<dockerhub_username>` | Docker Hub 사용자명 | ❌ 반드시 확인 필요 |
| `<new_tag>` | 배포할 새 이미지 태그 | ❌ 반드시 확인 필요 |

## 주의사항 (Cautions)
- ⛔ 7.4의 Blue-Green 리소스를 먼저 삭제해야 함 — 같은 이름의 Rollout 충돌 방지
- ⛔ `<dockerhub_username>`을 임의로 채우지 말 것 — 수강생의 실제 Docker Hub 계정 사용
- ✅ 첫 번째 `pause: {}`는 무기한 대기 — 반드시 수동 `promote` 필요
- ✅ 이후 `pause: {duration: 30s}`는 30초 후 자동 진행
- ✅ `kubectl argo rollouts abort worklog-backend`로 언제든 Canary를 중단(롤백) 가능
