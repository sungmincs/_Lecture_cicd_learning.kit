# Check Load balancer IP
## The external IP of the following output should be 192.168.1.11
kubectl get svc -n ingress-nginx ingress-nginx-controller

## Open this file using `Notepad` via administrator mode
C:\Windows\System32\drivers\etc\hosts
## add following lines
```
192.168.1.11 worklog-frontend.myk8s.local
192.168.1.11 worklog-backend.myk8s.local
```

# Update `hosts` file in the host computer

# Deploy worklog stacks to the Kubernetes cluster
## Deployment
kubectl apply -f ./worklog_manifests
## Verify Deployments are running
kubectl get pods
## Access from host network via
```
http://worklog-frontend.myk8s.local
```
## Try to add a few items from UI and show the swagger
```
http://worklog-backend.myk8s.local
```

# Update the build and push
cd ~/workspace/worklog-frontend/
vim src/widgets/lsb/index.tsx
## change line 46 "Summary" to "Dates"
docker build . -t <dockerhub_username>/worklog-frontend:buildtest2
docker push <dockerhub_username>/worklog-frontend:buildtest2

# Update the manifest and redeploy
cd ~/_Lecture_cicd_learning.kit/ch3/3.4
## Modify the image tag for frontend
vim worklog_manifests/worklog-frontend.yaml
kubectl edit deployment worklog-frontend
### update the image tag to <dockerhub_username>/worklog-frontend:buildtest2
### and verify the text gets updated
http://worklog-frontend.myk8s.local

# Cleanup
kubectl delete -f ./worklog_manifests
