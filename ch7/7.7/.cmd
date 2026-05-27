# Review Worklog App architecture
## Frontend: React app (worklog-frontend_v1)
## Backend: Python FastAPI (worklog-backend_v1)
## Database: MongoDB

# Deploy MongoDB
kubectl apply -f 1.mongodb-manifest.yaml

# Verify MongoDB
kubectl get pods -l app=mongodb
kubectl get svc mongodb

# Deploy Backend with DB connection
kubectl apply -f 2.worklog-backend-with-db.yaml

# Verify Backend connects to DB
kubectl logs -l app=worklog-backend --tail=20

# Deploy Frontend
kubectl apply -f 3.worklog-frontend-manifest.yaml

# Verify full stack
kubectl get pods
## Access: http://worklog-frontend.myk8s.local
