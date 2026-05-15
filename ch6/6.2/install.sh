#!/bin/bash
set -x

kubectl create namespace argocd || true
kubectl apply -n argocd -f ./argocd-manifest.yaml
kubectl apply -n argocd -f ./argocd-notification-catalog.yaml

# Ingress → HTTPRoute (Gateway API) 전환
# argocd-manifest.yaml의 Ingress(nginx 기반)를 삭제하고 HTTPRoute로 대체
kubectl delete ingress argocd-server-http-ingress argocd-server-grpc-ingress -n argocd 2>/dev/null || true
kubectl apply -f ./argocd-httproute.yaml


# To enable notification for the argo app
# kubectl patch app <my-app> -n argocd -p '{"metadata": {"annotations": {"notifications.argoproj.io/subscribe.on-deployed.slack":"dev_bots", "notifications.argoproj.io/subscribe.on-health-degraded.slack":"dev_bots", "notifications.argoproj.io/subscribe.on-sync-failed.slack":"dev_bots"}}}' --type merge
