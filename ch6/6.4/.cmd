# Access Argo CD UI
## Get the initial admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
## Update hosts file
### Add: 192.168.1.99 argocd.myk8s.local
## Access Argo CD UI
### https://argocd.myk8s.local
### Login: admin / <initial_password>

# Install Argo CD CLI
## Linux (on control plane node)
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64

# Login via CLI
argocd login argocd.myk8s.local --username admin --password <initial_password> --insecure
argocd account list
