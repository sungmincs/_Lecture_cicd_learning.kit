#!/bin/bash
set -x

ARGO_ROLLOUTS_VERSION="v1.9.0"

kubectl create namespace argo-rollouts || true
kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/download/${ARGO_ROLLOUTS_VERSION}/install.yaml

# arm64 환경 감지 후 적합한 바이너리 다운로드
ARCH=$(uname -m)
if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
  BINARY="kubectl-argo-rollouts-linux-arm64"
else
  BINARY="kubectl-argo-rollouts-linux-amd64"
fi

curl -LO https://github.com/argoproj/argo-rollouts/releases/download/${ARGO_ROLLOUTS_VERSION}/${BINARY}
chmod +x ./${BINARY}
mv ./${BINARY} /usr/local/bin/kubectl-argo-rollouts
echo "Argo Rollouts ${ARGO_ROLLOUTS_VERSION} installed successfully"
kubectl argo rollouts version
