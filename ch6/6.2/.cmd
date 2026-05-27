# Argo CD 설치 및 구성

## argocd namespace 생성
kubectl create namespace argocd

## Argo CD manifest 적용 (핵심 컴포넌트 배포)
cd ~/_Lecture_cicd_learning.kit/ch6/6.2
kubectl apply -n argocd -f ./argocd-manifest.yaml

## Notification catalog 적용
kubectl apply -n argocd -f ./argocd-notification-catalog.yaml

## Ingress → HTTPRoute 전환 (Gateway API 기반 클러스터)
kubectl delete ingress argocd-server-http-ingress argocd-server-grpc-ingress -n argocd 2>/dev/null || true
kubectl apply -f ./argocd-httproute.yaml

## 설치 확인 (모든 pod Running 될 때까지 1~2분 대기)
kubectl get pods -n argocd
kubectl get pods -n argocd -w

## 서비스 확인
kubectl get svc -n argocd
