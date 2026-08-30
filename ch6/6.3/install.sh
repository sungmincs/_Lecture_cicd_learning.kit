#!/bin/bash
set -x

kubectl create namespace argocd || true
# ArgoCD v3.4.3 manifest는 대용량(33K줄)이라 client-side apply 시 annotation 한도 초과 →
# server-side apply 사용 (CRD 포함 정상 적용)
kubectl apply -n argocd --server-side --force-conflicts -f ./argocd-manifest.yaml
kubectl apply -n argocd -f ./argocd-notification-catalog.yaml

# 외부 노출은 HTTPRoute (Gateway API) — 본 manifest에는 nginx Ingress 없음(v3 전환 시 제거)
kubectl apply -f ./argocd-httproute.yaml


# To enable notification for the argo app
# kubectl patch app <my-app> -n argocd -p '{"metadata": {"annotations": {"notifications.argoproj.io/subscribe.on-deployed.slack":"dev_bots", "notifications.argoproj.io/subscribe.on-health-degraded.slack":"dev_bots", "notifications.argoproj.io/subscribe.on-sync-failed.slack":"dev_bots"}}}' --type merge
