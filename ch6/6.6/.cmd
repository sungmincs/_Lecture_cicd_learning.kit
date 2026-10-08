# Setup Slack App (Bot token)
## https://api.slack.com/apps -> Create New App -> OAuth & Permissions: chat:write -> Install to Workspace
## Copy Bot User OAuth Token (xoxb-...), create channel argocd-alerts and /invite the app

# Configure Argo CD notification secret
kubectl patch secret argocd-notifications-secret -n argocd --type merge \
  -p '{"stringData": {"slack-token": "<slack_bot_token>"}}'

# Merge templates and triggers into the 6.3 catalog (do not kubectl apply)
kubectl patch configmap argocd-notifications-cm -n argocd --type merge \
  --patch-file 1.argocd-notifications-cm.yaml

# Patch Application with notification annotations
kubectl patch app worklog-backend -n argocd -p '{"metadata": {"annotations": {"notifications.argoproj.io/subscribe.on-deployed.slack":"argocd-alerts", "notifications.argoproj.io/subscribe.on-health-degraded.slack":"argocd-alerts", "notifications.argoproj.io/subscribe.on-sync-failed.slack":"argocd-alerts"}}}' --type merge

# Test notification
## Make a code change and push to trigger sync
## Verify Slack notification arrives
