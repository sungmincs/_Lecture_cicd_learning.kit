# Cleanup blue-green resources
kubectl delete rollout worklog-backend
kubectl delete svc worklog-backend-active worklog-backend-preview

# Apply Canary Rollout
kubectl apply -f 1.worklog-backend-rollout-canary.yaml
kubectl apply -f 2.worklog-backend-service-canary.yaml

# Monitor rollout
kubectl argo rollouts get rollout worklog-backend --watch

# Update image to trigger canary deployment
kubectl argo rollouts set image worklog-backend worklog-backend=<dockerhub_username>/worklog-backend:<new_tag>

# Watch canary steps
kubectl argo rollouts get rollout worklog-backend --watch

# Promote through canary steps
kubectl argo rollouts promote worklog-backend

# Verify
kubectl get pods
