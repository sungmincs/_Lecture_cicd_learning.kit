# CI/CD 특화 트러블슈팅

## 현재 Pod 상태 확인
kubectl get pods
kubectl get events --sort-by='.lastTimestamp' | tail -20

## --- 시나리오 1: ImagePullBackOff ---
## 오류 재현 (의도적)
kubectl set image deployment/worklog-backend worklog-backend=<dockerhub_username>/worklog-backend:wrong-tag

## 오류 진단
kubectl get pods
kubectl describe pod <pod-name>
# Events에서 "Failed to pull image" 확인

## 복구
kubectl set image deployment/worklog-backend worklog-backend=<dockerhub_username>/worklog-backend:buildtest1
kubectl rollout status deployment/worklog-backend

## --- 시나리오 2: CrashLoopBackOff ---
## (의도적으로 환경변수 누락 → 앱이 시작 직후 종료)

## 오류 진단
kubectl logs <pod-name>
kubectl logs <pod-name> --previous

## 시작 직후 종료되는 컨테이너 로그 확인
kubectl describe pod <pod-name>

## --- 시나리오 3: readinessProbe 실패 ---
## Pod가 Running이지만 트래픽을 받지 못하는 상황

## 진단
kubectl describe pod <pod-name>
# Events에서 "Readiness probe failed" 확인

kubectl get endpoints worklog-backend
# 정상이면 IP 표시, readiness 실패면 <none>

## Pod 내부에서 health endpoint 직접 테스트
kubectl exec -it <pod-name> -- curl -s localhost:80/health

## --- 공통: 이벤트 기반 진단 ---
kubectl get events --sort-by='.lastTimestamp'
kubectl get events --field-selector reason=Failed

## 정리
kubectl delete -f ~/_Lecture_cicd_learning.kit/ch3/3.6/worklog_manifests
