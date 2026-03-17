# GUARDRAIL: 7.2 Rolling Update, Blue-Green, Canary 등 다양한 배포 전략들

## 범위 (Scope)
### 이 단계에서 다루는 것
- Rolling Update, Blue-Green, Canary, A/B Testing 배포 전략의 개념과 차이
- 각 전략의 장단점 비교
- 어떤 상황에서 어떤 전략을 사용하는지 판단 기준

### 이 단계에서 다루지 않는 것
- Argo Rollouts 설치 (7.3에서 다룸)
- Blue-Green 실습 (7.4에서 다룸)
- Canary 실습 (7.5에서 다룸)
- 실제 클러스터에서의 명령 실행

## 사전 조건 (Prerequisites)
- ch6 완료 (Argo CD 설치 및 파이프라인 구성 이해)
- Kubernetes Deployment의 Rolling Update 전략에 대한 기본 이해

## 순서 (Sequence)
### Step 1: 배포 전략 개념 학습
- Rolling Update: K8s 기본 전략, `maxSurge`/`maxUnavailable` 설정
- 기대 결과: 각 전략의 동작 방식을 설명할 수 있음

### Step 2: Blue-Green 전략 이해
- Active 환경과 Preview 환경의 역할 이해
- 기대 결과: 트래픽 전환 과정을 설명할 수 있음

### Step 3: Canary 전략 이해
- 트래픽 가중치 단계적 이동의 개념
- 기대 결과: Canary 단계별 동작을 설명할 수 있음

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| 개념 이해 | 각 전략 설명 가능 | Rolling, Blue-Green, Canary, A/B 차이 설명 |
| 판단 기준 | 시나리오별 적합한 전략 선택 | 상황에 맞는 전략을 고를 수 있음 |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| (없음) | 이론 섹션이므로 플레이스홀더 없음 | - |

## 주의사항 (Cautions)
- ⛔ 이 섹션에서 실습 명령을 실행하지 않는다 — 이론 학습만 진행
- ✅ 각 전략의 트레이드오프를 충분히 이해한 후 7.3 이후 실습으로 진행
- ✅ K8s 기본 Rolling Update와 Argo Rollouts의 차이를 명확히 구분
