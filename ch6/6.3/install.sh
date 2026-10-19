#!/bin/bash
set -x

kubectl create namespace argocd || true
# ApplicationSet 같은 일부 CRD는 크기가 커서 client-side apply가 남기는
# last-applied annotation 한도(262KB)를 넘는다. server-side apply는 이 annotation을
# 저장하지 않으므로 한도에 걸리지 않는다(Argo CD v3.4.3 공식 설치 안내)
kubectl apply -n argocd --server-side --force-conflicts -f ./argocd-manifest.yaml
kubectl apply -n argocd -f ./argocd-notification-catalog.yaml

# 외부 노출은 HTTPRoute (Gateway API) — 본 manifest에는 nginx Ingress 없음(v3 전환 시 제거)
kubectl apply -f ./argocd-httproute.yaml


# To enable notification for the argo app
# kubectl patch app <my-app> -n argocd -p '{"metadata": {"annotations": {"notifications.argoproj.io/subscribe.on-deployed.slack":"argocd-alerts", "notifications.argoproj.io/subscribe.on-health-degraded.slack":"argocd-alerts", "notifications.argoproj.io/subscribe.on-sync-failed.slack":"argocd-alerts"}}}' --type merge
