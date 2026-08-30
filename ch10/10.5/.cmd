# Deploy Worklog App to EKS (manual)
## Apply MongoDB, Backend, Frontend from ch8
kubectl apply -f ~/_Lecture_cicd_learning.kit/ch8/8.2/1.mongodb-manifest.yaml
kubectl apply -f ~/_Lecture_cicd_learning.kit/ch8/8.2/2.worklog-backend-with-db.yaml
kubectl apply -f ~/_Lecture_cicd_learning.kit/ch8/8.2/3.worklog-frontend-manifest.yaml

# Verify deployment
kubectl get pods
kubectl get svc
kubectl get ingress

# Install Argo CD on EKS
kubectl create namespace argocd
kubectl apply -n argocd -f ~/_Lecture_cicd_learning.kit/ch6/6.2/argocd-manifest.yaml

# Expose Argo CD via LoadBalancer
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

# Get Argo CD URL
kubectl get svc argocd-server -n argocd

# Get initial password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# Access Argo CD UI
### Open LoadBalancer URL in browser, login with admin/<password>
