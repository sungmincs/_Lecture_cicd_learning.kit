# Register Git repository in Argo CD
## Via CLI
argocd repo add https://github.com/<github_username>/worklog-backend_v1.git

# Create Argo CD Application
## Via CLI
argocd app create worklog-backend \
  --repo https://github.com/<github_username>/worklog-backend_v1.git \
  --path deploy_manifest \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace default \
  --sync-policy automated

## Verify in UI
### Check Application status in Argo CD dashboard

# Sync Application
argocd app sync worklog-backend

# Verify deployment
kubectl get pods
kubectl get svc
