# GUARDRAIL: 8.2 배포 환경의 중요성 (namespace 분리)

## 범위 (Scope)
### 이 단계에서 다루는 것
- Kubernetes namespace를 이용한 배포 환경 분리 (dev/staging/prod) 개념
- 각 namespace 생성 및 environment 레이블 설정
- 멀티 환경 운영의 필요성과 실무 패턴 이해

### 이 단계에서 다루지 않는 것
- 실제 CI/CD 파이프라인 구현 (8.4~8.9에서 다룸)
- PR/Branch/Tag 기반 배포 전략 이론 (8.3에서 다룸)
- NetworkPolicy, ResourceQuota 등 namespace 수준 보안/자원 제한
- Helm values 파일을 이용한 환경별 설정 분리

## 사전 조건 (Prerequisites)
- ch2 완료 (Kubernetes 클러스터 구성 및 kubectl 접속 가능)

## 순서 (Sequence)
### Step 1: dev namespace 생성 [학습자 직접]
- 명령어: `kubectl create namespace dev`
- 기대 결과: namespace/dev created

### Step 2: staging namespace 생성 [학습자 직접]
- 명령어: `kubectl create namespace staging`
- 기대 결과: namespace/staging created

### Step 3: prod namespace 생성 [학습자 직접]
- 명령어: `kubectl create namespace prod`
- 기대 결과: namespace/prod created

### Step 4: namespace 목록 확인 [학습자 직접]
- 명령어: `kubectl get namespaces`
- 기대 결과: dev, staging, prod namespace가 Active 상태로 표시

### Step 5: environment 레이블 추가 [학습자 직접]
- 명령어: `kubectl label namespace dev environment=development`
- 명령어: `kubectl label namespace staging environment=staging`
- 명령어: `kubectl label namespace prod environment=production`
- 기대 결과: 각 namespace에 environment 레이블 추가됨

### Step 6: 레이블 확인 [학습자 직접]
- 명령어: `kubectl get namespaces --show-labels`
- 기대 결과: 각 namespace에 environment 레이블이 표시됨

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| namespace 생성 | `kubectl get namespaces` | dev, staging, prod 모두 Active |
| 레이블 확인 | `kubectl get namespaces --show-labels` | environment=development/staging/production 표시 |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| 없음 | - | - |

## 주의사항 (Cautions)
- ⛔ 이미 존재하는 namespace에 대해 `kubectl create namespace`를 실행하면 에러가 발생한다. 이 경우 무시하거나 `kubectl create namespace dev --dry-run=client -o yaml | kubectl apply -f -` 를 사용한다.
- ⛔ prod namespace에 실수로 테스트 워크로드를 배포하지 않도록 주의한다.
- ✅ namespace 분리는 논리적 격리이며, 완전한 보안 격리가 필요하면 별도 클러스터를 사용한다.
- ✅ 이 단계에서 생성한 namespace는 이후 8.4~8.9에서 계속 사용된다.
