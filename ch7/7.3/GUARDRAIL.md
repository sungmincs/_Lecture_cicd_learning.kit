# GUARDRAIL: 7.3 Rolling Update 배포 실습

## 범위 (Scope)
### 이 단계에서 다루는 것
- Kubernetes 기본 Deployment의 Rolling Update 전략 실습
- maxSurge, maxUnavailable 설정에 따른 배포 동작 확인
- 이미지 업데이트 시 Pod가 순차적으로 교체되는 과정 관찰
- Rolling Update의 한계 인식 (트래픽 제어 불가, 즉시 롤백 어려움)

### 이 단계에서 다루지 않는 것
- Argo Rollouts 설치 (7.4에서 다룸)
- Blue-Green 배포 (7.5에서 다룸)
- Canary 배포 (7.6에서 다룸)

## 사전 조건 (Prerequisites)
- ch6 완료 (Argo CD 설치 및 파이프라인 구성)
- Docker Hub에 worklog-backend 이미지가 2개 이상의 태그로 존재
- Kubernetes 클러스터 접속 가능

## 순서 (Sequence)
### Step 1: Deployment 배포 [학습자 직접]
- 명령어: `kubectl apply -f 1.worklog-backend-deployment-rolling.yaml`
- 기대 결과: worklog-backend Deployment 생성, Pod 3개 Running

### Step 2: Rolling Update 설정 확인 [학습자 직접]
- 명령어: `kubectl describe deployment worklog-backend | grep -A5 Strategy`
- 기대 결과: RollingUpdate strategy, maxSurge=1, maxUnavailable=0 확인

### Step 3: 이미지 업데이트로 Rolling Update 트리거 [AI 프롬프트]
- 명령어: `kubectl set image deployment/worklog-backend worklog-backend=<dockerhub_username>/worklog-backend:<new_tag>`
- 명령어: `kubectl rollout status deployment/worklog-backend`
- 기대 결과: Pod가 하나씩 교체되는 과정 확인

### Step 4: 롤백 실습 [학습자 직접]
- 명령어: `kubectl rollout undo deployment/worklog-backend`
- 명령어: `kubectl rollout status deployment/worklog-backend`
- 기대 결과: 이전 버전으로 롤백 완료

### Step 5: 리소스 정리 [학습자 직접]
- 명령어: `kubectl delete deployment worklog-backend`
- 기대 결과: 다음 실습(7.4~7.6)을 위해 정리 완료

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| Deployment | `kubectl get deployment worklog-backend` | 3/3 Ready |
| 전략 확인 | `kubectl describe deployment` | RollingUpdate, maxSurge=1 |
| 업데이트 | `kubectl rollout status` | Pod 순차 교체 확인 |
| 롤백 | `kubectl rollout history` | REVISION 2개 이상 |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| `<dockerhub_username>` | Docker Hub 사용자명 | ❌ 반드시 확인 필요 |
| `<new_tag>` | 배포할 새 이미지 태그 | ❌ 반드시 확인 필요 |

## 주의사항 (Cautions)
- ⛔ `<dockerhub_username>`을 임의로 채우지 말 것
- ⛔ **[필수] Step 5 리소스 정리를 반드시 수행할 것** — 7.5(Blue-Green)/7.6(Canary)는 Argo Rollouts의 `kind: Rollout`을 사용하며, 기존 `kind: Deployment`와 같은 이름으로 공존할 수 없음. 정리하지 않으면 Rollout 생성 시 충돌 발생
- ✅ Rolling Update는 K8s 기본 기능 — Argo Rollouts 없이 동작
- ✅ 7.5(Blue-Green), 7.6(Canary)와 비교하기 위한 베이스라인 실습
