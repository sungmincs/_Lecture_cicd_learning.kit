# Apply Blue-green Rollout
kubectl apply -f 1.worklog-backend-rollout-bluegreen.yaml
kubectl apply -f 2.worklog-backend-services-bluegreen.yaml

# Monitor rollout status
kubectl argo rollouts get rollout worklog-backend --watch

# Update image to trigger blue-green deployment
kubectl argo rollouts set image worklog-backend worklog-backend=<dockerhub_username>/worklog-backend:<new_tag>

# Watch the promotion
kubectl argo rollouts get rollout worklog-backend --watch

# Promote the new version
kubectl argo rollouts promote worklog-backend

# Verify
kubectl get pods
kubectl get svc
