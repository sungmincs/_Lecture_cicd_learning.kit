# 9.8 CD 강화 — 자동 롤백 (Argo Rollouts AnalysisTemplate)

# AnalysisTemplate 적용
kubectl apply -f ~/_Lecture_cicd_learning.kit/ch9/9.8/1.analysis-template.yaml
kubectl get analysistemplate

# Rollout 적용
kubectl apply -f ~/_Lecture_cicd_learning.kit/ch9/9.8/2.rollout-with-analysis.yaml
kubectl argo rollouts get rollout worklog-backend

# 새 이미지 배포로 롤아웃 트리거
kubectl argo rollouts set image worklog-backend worklog-backend=<dockerhub_username>/worklog-backend:<new_tag>

# 롤아웃 진행 상황 실시간 확인
kubectl argo rollouts get rollout worklog-backend --watch

# Argo Rollouts 대시보드 실행 (브라우저에서 확인)
kubectl argo rollouts dashboard

# AnalysisRun 상태 확인
kubectl get analysisrun

# 롤백 수동 실행 (자동 롤백이 안 된 경우)
kubectl argo rollouts abort worklog-backend
kubectl argo rollouts undo worklog-backend