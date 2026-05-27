# GUARDRAIL: 3.7 이미지 업데이트와 수동 재배포 — "왜 CI/CD가 필요한가"

## 범위 (Scope)
### 이 단계에서 다루는 것
- 코드 수정 → Docker 재빌드 → push → K8s 이미지 업데이트의 전체 흐름 체험
- 수동 배포의 불편함을 직접 느끼기 → CI/CD 필요성 체감
- `kubectl set image`와 `kubectl apply` 두 가지 배포 방법 비교

### 이 단계에서 다루지 않는 것
- CI/CD 파이프라인 자동화 (ch4~에서 다룸)

## 사전 조건
- 3.6 완료 (worklog 스택이 K8s에 배포된 상태)
- 브라우저에서 `http://worklog-frontend.myk8s.local` 접속 확인 완료

## 실행 지침

### 단계 1: 코드 변경 `[AI 프롬프트]`

> "worklog-frontend-mock 소스코드에서 'Summary'라는 텍스트를 찾아서 'Dates'로 바꿔줘"

변경 후 눈으로 확인.

### 단계 2: 이미지 재빌드 & push `[학습자 직접]`

```bash
cd ~/workspace/worklog-frontend-mock
docker build . -t <dockerhub_username>/worklog-frontend-mock:buildtest2
docker push <dockerhub_username>/worklog-frontend-mock:buildtest2
```

### 단계 3: K8s에 새 이미지 배포 `[학습자 직접]`

```bash
kubectl set image deployment/worklog-frontend \
  worklog-frontend=<dockerhub_username>/worklog-frontend-mock:buildtest2
kubectl rollout status deployment/worklog-frontend
```

### 단계 4: 변경 확인 `[학습자 직접]`

브라우저에서 `http://worklog-frontend.myk8s.local` 새로고침 → 텍스트 변경 확인

### 단계 5: 수동 배포의 불편함 토론 `[AI 프롬프트]`

> "내가 방금 한 작업을 매번 수동으로 해야 한다면 어떤 문제가 생길 수 있어? CI/CD 파이프라인이 이 과정을 자동화하면 구체적으로 어떤 단계가 사라지는 거야?"

**강사 보충 포인트:**
- 방금 한 일: 코드 수정 → 빌드 → push → set image → 확인 (5단계)
- CI/CD가 자동화하는 것: git push 하나로 나머지 4단계가 자동 실행
- 실수 가능성: 이미지 태그 오타, push 빠뜨림, 잘못된 클러스터에 배포
- 팀 협업: 10명이 각자 수동 배포하면 누가 무엇을 배포했는지 추적 불가

### 단계 6: 정리 `[학습자 직접]`

```bash
kubectl delete -f ~/_Lecture_cicd_learning.kit/ch3/3.6/worklog_manifests
```

## 주의사항
- ✅ AI가 해도 됨: 코드 텍스트 수정, yaml 이미지 태그 교체, 단계 설명
- ⛔ 학습자가 직접 해야 함: `docker build`, `docker push`, `kubectl set image` (수동 배포 불편함을 직접 느껴야 함)
- 이 섹션의 핵심은 **완성이 아니라 불편함** — "이 과정을 매번 하기는 힘들다"는 느낌이 목표
