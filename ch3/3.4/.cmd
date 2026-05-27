# Docker 빌드 & Docker Hub push

## Docker Hub 가입/로그인
https://hub.docker.com/

## Docker login
docker login

## worklog-backend 빌드 & push
cd ~/workspace/worklog-backend
docker build . -t <dockerhub_username>/worklog-backend:buildtest1
docker push <dockerhub_username>/worklog-backend:buildtest1

## worklog-frontend 빌드 & push
cd ~/workspace/worklog-frontend-mock
docker build . -t <dockerhub_username>/worklog-frontend-mock:buildtest1
docker push <dockerhub_username>/worklog-frontend-mock:buildtest1

## 빌드된 이미지 확인
docker images | grep worklog

## 멀티스테이지 빌드 레이어 확인 (3.3 Dockerfile 분석 복습)
docker history <dockerhub_username>/worklog-backend:buildtest1

## Docker Hub에서 push된 이미지 확인
https://hub.docker.com/repositories/<dockerhub_username>
