# GUARDRAIL: 9.7 CD 강화 — prod 수동 승인 게이트

## 범위 (Scope)
### 이 단계에서 다루는 것
- Argo CD Application의 syncPolicy를 제거하여 prod 자동 배포 비활성화
- CI 파이프라인 통과 후에도 prod에는 사람이 수동으로 Argo CD Sync를 실행해야 배포
- dev/staging은 자동, prod는 수동이라는 환경별 자동화 수준 차등 적용 체험
- Argo CD UI 또는 CLI로 수동 Sync 실행

### 이 단계에서 다루지 않는 것
- GitHub Actions의 environment approval (GitHub 방식 승인)
- Jenkins의 input() 수동 승인 단계
- 자동 롤백 (9.8에서 다룸)
- 멀티 환경 Argo CD Application 초기 생성 (ch8에서 다룸)

## 사전 조건 (Prerequisites)
- ch8 완료 (멀티환경 파이프라인 + Argo CD Application 구성)
- dev/staging/prod namespace 존재
- Argo CD에 worklog-backend-dev, worklog-backend-staging, worklog-backend-prod Application 존재
- 학습자 fork 저장소에 기존 파이프라인 파일 존재
- 9.6 완료 (Trivy 이미지 스캔 단계 추가)

## 순서 (Sequence)

### Step 1: prod Application 매니페스트 복사 [학습자 직접]
- 명령어: `cp ~/_Lecture_cicd_learning.kit/ch9/9.7/1.argocd-prod-manual.yaml 1.argocd-prod-manual.yaml`
- 기대 결과: 현재 디렉토리에 Argo CD Application YAML 파일 생성

### Step 2: 플레이스홀더 수정 [AI 프롬프트]
- `<github_username>` 수정
- AI 프롬프트 예시: "1.argocd-prod-manual.yaml의 <github_username>을 내 GitHub 계정명으로 바꿔줘"

### Step 3: Argo CD prod Application에 syncPolicy 제거 적용 [학습자 직접]
방법 1 - YAML 파일 적용:
```
kubectl apply -f 1.argocd-prod-manual.yaml
```
방법 2 - kubectl patch로 직접 수정:
```
kubectl patch application worklog-backend-prod -n argocd --type merge -p '{"spec":{"syncPolicy":null}}'
```
- 기대 결과: prod Application의 AUTO-SYNC가 비활성화됨

### Step 4: dev/staging 자동 sync 확인 [학습자 직접]
- 명령어: `kubectl get application -n argocd`
- 기대 결과: dev, staging은 AUTO-SYNC: Enabled, prod는 AUTO-SYNC: <disabled>

### Step 5: 전체 흐름 테스트 [학습자 직접]
- 코드 변경 후 push → CI 파이프라인 통과 → dev/staging 자동 배포
- prod는 Argo CD UI에서 "SYNC" 버튼을 눌러야 배포됨
- 기대 결과: prod가 OutOfSync 상태에서 대기 중임 확인

### Step 6: prod 수동 승인 후 배포 확인 [학습자 직접]
- Argo CD UI → worklog-backend-prod → SYNC 클릭 또는:
  ```
  argocd app sync worklog-backend-prod
  ```
- 명령어: `kubectl get pods -n prod`
- 기대 결과: prod에 새 이미지로 배포 완료

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| prod AUTO-SYNC 비활성화 | `kubectl get application worklog-backend-prod -n argocd` | syncPolicy 없음 |
| dev 자동 배포 | `kubectl get pods -n dev` | 코드 변경 후 자동 반영 |
| staging 자동 배포 | `kubectl get pods -n staging` | 코드 변경 후 자동 반영 |
| prod 대기 상태 | Argo CD UI | OutOfSync 상태 |
| prod 수동 승인 후 | `kubectl get pods -n prod` | 새 이미지로 배포 완료 |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| `<github_username>` | GitHub 사용자 이름 | ❌ 반드시 확인 필요 |

## 환경별 자동화 수준 (9.7~9.8 전체 기준)

| 환경 | syncPolicy | 배포 방식 | Rollout/AnalysisTemplate |
|------|------------|----------|--------------------------|
| dev | 자동 | Argo CD 자동 Sync | 미사용 |
| staging | 자동 | Argo CD 자동 Sync | 미사용 |
| prod | **없음 (9.7에서 제거)** | **수동 Sync만 가능** | **미사용 — 9.8 해당 없음** |

> **9.8의 AnalysisTemplate은 prod에 적용하지 않는다.**
> prod는 이 단계(9.7)에서 수동 승인 방식으로 확정됨. Rollout 자동 롤백은 dev/staging 전용.

## 주의사항 (Cautions)
- ⛔ prod에 syncPolicy를 다시 추가하면 자동 배포가 재활성화된다 — 실수하지 않도록 주의
- ⛔ Argo CD CLI(argocd)를 사용하려면 argocd login이 먼저 되어 있어야 한다
- ⛔ 9.8에서 AnalysisTemplate을 구성할 때 prod namespace에는 적용하지 말 것 — prod는 이 단계에서 수동 승인으로 확정됨
- ✅ "AI가 빠르게 코드를 생성하더라도, prod 배포 결정은 사람이 한다"가 이 단계의 핵심 메시지
- ✅ Argo CD UI의 SYNC 버튼이 "사람의 승인 게이트" 역할을 한다 — 구조적으로 prod를 보호하는 방식
