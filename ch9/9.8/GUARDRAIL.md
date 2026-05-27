# GUARDRAIL: 9.8 CD 강화 — 자동 롤백 (Argo Rollouts AnalysisTemplate)

## 범위 (Scope)
### 이 단계에서 다루는 것
- AnalysisTemplate으로 HTTP 헬스체크 기반 자동 롤백 조건 정의
- Rollout(Canary 전략)에 AnalysisTemplate 연결
- 카나리 배포 중 성공률이 95% 미만이면 자동 롤백 동작 체험
- Argo Rollouts의 자동화된 배포 안전망 구성

### 이 단계에서 다루지 않는 것
- Argo Rollouts 기본 설치 및 Blue/Green 전략 (ch7에서 다룸)
- prod 수동 승인 게이트 (9.7에서 다룸)
- Prometheus 메트릭 기반 AnalysisTemplate (심화 내용)
- Argo Rollouts와 Argo CD 연동 심화

## 사전 조건 (Prerequisites)
- ch7/7.4 완료 (Argo Rollouts 설치)
- ch7/7.6 완료 (Canary Rollout 기본 구성)
- ch8 완료 (멀티환경 파이프라인 구성)
- dev/staging/prod namespace 존재
- worklog-backend에 `/health` 엔드포인트 존재

## 순서 (Sequence)

### Step 1: AnalysisTemplate 매니페스트 복사 [학습자 직접]
- 명령어: `cp ~/_Lecture_cicd_learning.kit/ch9/9.8/1.analysis-template.yaml 1.analysis-template.yaml`
- 기대 결과: 현재 디렉토리에 AnalysisTemplate YAML 생성

### Step 2: AnalysisTemplate 적용 [학습자 직접]
- 명령어: `kubectl apply -f 1.analysis-template.yaml`
- 기대 결과: AnalysisTemplate "success-rate" 생성됨
- 확인: `kubectl get analysistemplate -n default`

### Step 3: Rollout 매니페스트 복사 및 수정 [AI 프롬프트]
- 명령어: `cp ~/_Lecture_cicd_learning.kit/ch9/9.8/2.rollout-with-analysis.yaml 2.rollout-with-analysis.yaml`
- AI 프롬프트 예시: "2.rollout-with-analysis.yaml의 <dockerhub_username>을 내 Docker Hub 계정명으로 바꿔줘"

### Step 4: Rollout 적용 [학습자 직접]
- 명령어: `kubectl apply -f 2.rollout-with-analysis.yaml`
- 기대 결과: worklog-backend Rollout이 Canary 전략 + AnalysisTemplate으로 실행됨
- 확인: `kubectl argo rollouts get rollout worklog-backend`

### Step 5: 새 이미지 배포로 롤아웃 트리거 [학습자 직접]
- 명령어:
  ```
  kubectl argo rollouts set image worklog-backend worklog-backend=<dockerhub_username>/worklog-backend:<new_tag>
  ```
- 기대 결과: Canary 배포 시작, 20% → 40% → 80% 단계별 진행
- 확인: `kubectl argo rollouts get rollout worklog-backend --watch`

### Step 6: 자동 롤백 체험 (선택) [학습자 직접]
- 잘못된 이미지 배포로 헬스체크 실패 유도
- 기대 결과: failureLimit(3) 초과 시 자동 롤백 발생

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| AnalysisTemplate 생성 | `kubectl get analysistemplate` | success-rate 존재 |
| Rollout 생성 | `kubectl get rollout` | worklog-backend Canary 전략 |
| 배포 진행 | `kubectl argo rollouts get rollout worklog-backend` | 단계별 weight 증가 |
| 헬스체크 통과 | AnalysisRun 상태 확인 | Successful |
| 자동 롤백 | AnalysisRun 실패 시 Rollout 상태 | Degraded → rollback 완료 |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| `<dockerhub_username>` | Docker Hub 사용자 이름 | ❌ 반드시 확인 필요 |
| `<image_tag>` | 배포할 이미지 태그 | ❌ 반드시 확인 필요 |

## 주의사항 (Cautions)
- ⛔ AnalysisTemplate의 url을 `http://worklog-backend/health`로 설정했으므로 worklog-backend Service가 존재해야 한다
- ⛔ successCondition의 jsonPath `{$.status}`는 `/health` 응답에서 "ok" 값이 있어야 한다 — 앱의 헬스 응답 구조 확인 필요
- ⛔ Rollout을 사용하면 기존 Deployment와 공존할 수 없다 — 기존 Deployment를 삭제하고 Rollout으로 교체해야 한다
- ✅ `kubectl argo rollouts dashboard` 명령으로 브라우저에서 롤아웃 진행 상황을 시각적으로 확인할 수 있다
- ✅ failureLimit: 3은 3번 실패 후 롤백 — 실제 환경에서는 심각도에 따라 조정한다
