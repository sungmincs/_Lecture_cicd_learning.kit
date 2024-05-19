# Docker build and push
## Join or signin Docker hub (https://hub.docker.com/)
https://hub.docker.com/

## build docker container
### build Frontend
cd ~/workspace/worklog-frontend
docker build . -t <dockerhub_username>/worklog-frontend:buildtest1
#### This should fail with permission denied error
#### `denied: requested access to the resource is denied`
docker push <dockerhub_username>/worklog-frontend:buildtest1
docker login
docker push <dockerhub_username>/worklog-frontend:buildtest1

### build Backend
cd ~/workspace/worklog-backend
docker build . -t <dockerhub_username>/worklog-backend:buildtest1
docker push <dockerhub_username>/worklog-backend:buildtest1

## show built docker images
https://hub.docker.com
