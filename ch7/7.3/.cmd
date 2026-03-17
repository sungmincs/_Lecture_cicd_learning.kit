# Deploy worklog-backend with Rolling Update strategy
kubectl apply -f 1.worklog-backend-deployment-rolling.yaml

# Verify deployment
kubectl get deployment worklog-backend
kubectl get pods -l app=worklog-backend

# Check Rolling Update strategy
kubectl describe deployment worklog-backend | grep -A5 Strategy

# Trigger Rolling Update by changing image
kubectl set image deployment/worklog-backend worklog-backend=<dockerhub_username>/worklog-backend:<new_tag>

# Watch rolling update progress
kubectl rollout status deployment/worklog-backend

# Verify new pods
kubectl get pods -l app=worklog-backend

# Rollback to previous version
kubectl rollout undo deployment/worklog-backend
kubectl rollout status deployment/worklog-backend

# Check rollout history
kubectl rollout history deployment/worklog-backend

# Cleanup for next sections
kubectl delete deployment worklog-backend
