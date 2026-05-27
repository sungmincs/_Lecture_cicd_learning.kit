# Create namespaces for multi-environment
## dev 환경 namespace 생성
kubectl create namespace dev

## staging 환경 namespace 생성
kubectl create namespace staging

## prod 환경 namespace 생성
kubectl create namespace prod

# Verify namespaces
kubectl get namespaces

# Label namespaces for environment identification
## dev namespace에 environment 레이블 추가
kubectl label namespace dev environment=development

## staging namespace에 environment 레이블 추가
kubectl label namespace staging environment=staging

## prod namespace에 environment 레이블 추가
kubectl label namespace prod environment=production

# Verify labels
kubectl get namespaces --show-labels
