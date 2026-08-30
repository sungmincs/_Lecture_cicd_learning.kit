# Setup Slack Webhook
## Create Slack App and get webhook URL
### https://api.slack.com/apps

# Configure Argo CD notification secret
kubectl create secret generic argocd-notifications-secret \
  -n argocd \
  --from-literal=slack-token=<slack_webhook_url> \
  --dry-run=client -o yaml | kubectl apply -f -

# Patch Application with notification annotations
kubectl patch app worklog-backend -n argocd -p '{"metadata": {"annotations": {"notifications.argoproj.io/subscribe.on-deployed.slack":"dev_bots", "notifications.argoproj.io/subscribe.on-health-degraded.slack":"dev_bots", "notifications.argoproj.io/subscribe.on-sync-failed.slack":"dev_bots"}}}' --type merge

# Test notification
## Make a code change and push to trigger sync
## Verify Slack notification arrives
