#!/bin/bash
set -e

VERSION="v1.9.0"

# Detect architecture
ARCH=$(uname -m)
if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
    PLUGIN_ARCH="arm64"
else
    PLUGIN_ARCH="amd64"
fi

echo "Installing Argo Rollouts ${VERSION} (arch: ${PLUGIN_ARCH})"

kubectl create namespace argo-rollouts || true
kubectl apply -n argo-rollouts \
    -f https://github.com/argoproj/argo-rollouts/releases/download/${VERSION}/install.yaml

curl -LO "https://github.com/argoproj/argo-rollouts/releases/download/${VERSION}/kubectl-argo-rollouts-linux-${PLUGIN_ARCH}"
chmod +x "./kubectl-argo-rollouts-linux-${PLUGIN_ARCH}"
mv "./kubectl-argo-rollouts-linux-${PLUGIN_ARCH}" /usr/local/bin/kubectl-argo-rollouts

echo "Argo Rollouts ${VERSION} installed successfully"
kubectl argo rollouts version
