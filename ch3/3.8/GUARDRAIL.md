# GUARDRAIL: 3.8 CI/CD 특화 트러블슈팅

## 범위 (Scope)
### 이 단계에서 다루는 것
- CI/CD 파이프라인에서 자주 발생하는 3가지 K8s 오류 패턴 진단
- ImagePullBackOff / CrashLoopBackOff / readinessProbe 실패
- 오류 → 진단 명령 → 원인 파악 → 복구의 흐름 체득

### 이 단계에서 다루지 않는 것
- 일반적인 K8s 운영 트러블슈팅 (사전 강의에서 다룸)
- 파이프라인 자체 오류 (4~6장에서 다룸)

## 사전 조건
- 3.6 완료 (K8s에 worklog 스택 배포 경험)
- worklog 스택이 배포된 상태이거나 재배포 가능한 상태

## 왜 이 오류들이 "CI/CD 특화"인가?

> "K8s 오브젝트 자체는 문제 없어도, CI/CD 파이프라인이 배포할 때 이 오류들이 가장 많이 발생한다":
>
> - **ImagePullBackOff**: 파이프라인이 push하기 전에 deploy했거나, 태그가 틀렸거나, registry 인증 누락
> - **CrashLoopBackOff**: 새 버전 이미지에 환경변수 누락, 잘못된 설정, 앱 버그
> - **readinessProbe 실패**: 배포는 됐는데 앱이 아직 준비 안 됨 → 트래픽 차단 → 파이프라인 타임아웃

---

## 시나리오 1: ImagePullBackOff `[학습자 직접 + AI 프롬프트]`

### 오류 재현 (의도적)
```bash
kubectl set image deployment/worklog-backend \
  worklog-backend=<dockerhub_username>/worklog-backend:wrong-tag
```

### 진단 `[학습자 직접]`
```bash
kubectl get pods
kubectl describe pod <pod-name>
```

이벤트 섹션에서 `Failed to pull image` 메시지 확인

### AI와 분석 `[AI 프롬프트]`

> "kubectl describe pod 결과를 붙여넣어줄게. ImagePullBackOff가 발생한 이유와 해결 방법을 알려줘"

### 복구 `[학습자 직접]`
```bash
kubectl set image deployment/worklog-backend \
  worklog-backend=<dockerhub_username>/worklog-backend:buildtest1
kubectl rollout status deployment/worklog-backend
```

**강사 보충 포인트:**
- CI/CD에서 ImagePullBackOff 3대 원인: ① 잘못된 태그 ② push 전에 deploy ③ imagePullSecrets 누락
- 파이프라인 설계: push → deploy 순서 보장이 핵심

---

## 시나리오 2: CrashLoopBackOff `[AI 프롬프트 중심]`

### 오류 특징 이해

> "CrashLoopBackOff와 ImagePullBackOff의 차이가 뭐야? CrashLoopBackOff는 이미지를 pull했는데도 왜 실패하는 거야?"

### 진단 명령 `[학습자 직접]`
```bash
kubectl logs <pod-name>
kubectl logs <pod-name> --previous
```

### AI와 분석 `[AI 프롬프트]`

> "kubectl logs 결과를 붙여줄게. CrashLoopBackOff 원인이 뭔지 분석해줘"

**강사 보충 포인트:**
- `--previous` 플래그: 이미 종료된 이전 컨테이너 로그 → CrashLoop 첫 번째 오류 확인에 필수
- CI/CD에서 CrashLoop 주요 원인: ① 환경변수 누락 ② Secret 이름 오타 ③ 앱 코드 버그 (새 이미지)
- 로그가 없는 경우: `kubectl describe pod`의 Exit Code 확인

---

## 시나리오 3: readinessProbe 실패 `[AI 프롬프트 중심]`

### 오류 패턴 이해

> "Pod가 Running 상태인데 kubectl get svc에서 ENDPOINTS가 없거나, 앱에 접속이 안 되는 경우 어떤 가능성이 있어?"

### 진단 `[학습자 직접]`
```bash
kubectl describe pod <pod-name>
# Conditions: Ready=False, Events: Readiness probe failed 확인

kubectl get endpoints worklog-backend
# 정상이면 IP 표시, readiness 실패면 <none>

kubectl exec -it <pod-name> -- curl -s localhost:80/health
# Pod 내부에서 직접 health endpoint 테스트
```

### AI와 분석 `[AI 프롬프트]`

> "describe pod 결과에서 Readiness probe failed가 보여. health endpoint가 /health인데 왜 실패하는지 분석해줘"

**강사 보충 포인트:**
- readinessProbe 실패 = Pod는 Running이지만 Service의 Endpoints에서 제외됨 → 트래픽 0
- CI/CD 맥락: 새 버전 배포 후 앱이 초기화되는 동안 readiness 실패 → `initialDelaySeconds` 설정 중요
- 파이프라인에서 `kubectl rollout status`가 타임아웃되는 주요 원인

---

## 트러블슈팅 판단 흐름도 `[AI 프롬프트]`

> "K8s Pod 오류 트러블슈팅 순서를 판단 흐름도로 정리해줘. kubectl get pods → 상태에 따라 다음 명령 순서"

```
kubectl get pods
  ├─ Pending     → kubectl describe pod (리소스 부족? 노드 스케줄링?)
  ├─ ImagePullBackOff → kubectl describe pod (이미지 태그? registry 인증?)
  ├─ CrashLoopBackOff → kubectl logs --previous (앱 오류? 환경변수?)
  ├─ Running (접속 안 됨) → kubectl describe pod (readiness? port?)
  └─ Running (정상) → kubectl logs (앱 동작 확인)
```

## 주의사항
- ✅ AI가 해도 됨: 오류 로그 분석, 원인 설명, 해결 방법 안내
- ✅ 학습자가 직접 해야 함: `kubectl describe`, `kubectl logs`, `kubectl exec`
- ⛔ AI가 하지 말 것: 오류 재현 명령 실행 (학습자가 직접 입력해야 오류 상황이 체감됨)
- 이 섹션의 핵심: **진단 명령 패턴 암기가 아니라, "어떤 오류 → 어떤 명령"의 판단 흐름 학습**
