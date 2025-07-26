#!/bin/bash
NGROK_URL=$1

if [ -z $NGROK_URL ]; then
  echo "usage: gen_sa_config.sh <NGROK_URL>"
  exit 1
fi

kubectl create serviceaccount control-plane-tunnel-sa
kubectl create clusterrolebinding kubeconfig-cluster-admin-token --clusterrole=cluster-admin --serviceaccount=default:control-plane-tunnel-sa
cat << EOF | kubectl apply -f -
---
apiVersion: v1
kind: Secret
metadata:
  name: kubeconfig-cluster-admin-token
  annotations:
    kubernetes.io/service-account.name: control-plane-tunnel-sa
type: kubernetes.io/service-account-token
EOF
decoded_token=$(kubectl get secret kubeconfig-cluster-admin-token -o jsonpath='{.data.token}' | base64 --decode)

cat << EOF > ~/.kube/control-plane-tunnel
---
apiVersionapiVersion: v1
clusters:
- cluster:
    server: ${NGROK_URL}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: control-plane-tunnel-sa
  name: cp-k8s-tunnel
current-context: cp-k8s-tunnel
kind: Config
preferences: {}
users:
- name: control-plane-tunnel-sa
  user:
    token: ${decoded_token}
EOF 
