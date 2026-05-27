# 9.7 CD 강화 — prod 수동 승인 게이트

# prod Argo CD Application에 syncPolicy 제거 (방법 1: YAML 적용)
kubectl apply -f ~/_Lecture_cicd_learning.kit/ch9/9.7/1.argocd-prod-manual.yaml

# prod Argo CD Application에 syncPolicy 제거 (방법 2: patch)
kubectl patch application worklog-backend-prod -n argocd --type merge -p '{"spec":{"syncPolicy":null}}'

# dev/staging AUTO-SYNC 활성화 확인
kubectl get application -n argocd

# prod Application 상태 확인 (OutOfSync 대기 상태)
kubectl get application worklog-backend-prod -n argocd

# prod 수동 Sync 실행 (Argo CD CLI)
argocd app sync worklog-backend-prod

# prod 수동 Sync 실행 (Argo CD UI 방식 확인용)
## Argo CD UI → worklog-backend-prod → SYNC 클릭

# 배포 확인
kubectl get pods -n dev
kubectl get pods -n staging
kubectl get pods -n prod