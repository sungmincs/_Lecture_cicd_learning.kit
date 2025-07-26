#!/bin/bash
set -x

kubectl create namespace argocd || true
kubectl apply -n argocd -f ./argocd-manifest.yaml
kubectl apply -n argocd -f ./argocd-notification-catalog.yaml


# To enable notification for the argo app
# kubectl patch app <my-app> -n argocd -p '{"metadata": {"annotations": {"notifications.argoproj.io/subscribe.on-deployed.slack":"dev_bots", "notifications.argoproj.io/subscribe.on-health-degraded.slack":"dev_bots", "notifications.argoproj.io/subscribe.on-sync-failed.slack":"dev_bots"}}}' --type merge
