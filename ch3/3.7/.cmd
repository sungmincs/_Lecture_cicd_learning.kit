# 이미지 업데이트와 수동 재배포 체험 — "왜 CI/CD가 필요한가"

## 현재 배포 확인
kubectl get pods
kubectl get deployment worklog-frontend -o wide

## 코드 변경 (프론트엔드 텍스트 수정)
cd ~/workspace/worklog-frontend-mock
## AI에게 "Summary" 텍스트가 있는 파일 찾아달라고 한 다음 수정
## 예: vim src/...

## 수정 후 이미지 재빌드 & push (buildtest2 태그)
docker build . -t <dockerhub_username>/worklog-frontend-mock:buildtest2
docker push <dockerhub_username>/worklog-frontend-mock:buildtest2

## K8s에 새 이미지 적용 (방법 1: kubectl set image)
kubectl set image deployment/worklog-frontend \
  worklog-frontend=<dockerhub_username>/worklog-frontend-mock:buildtest2

## 롤아웃 상태 확인
kubectl rollout status deployment/worklog-frontend

## 변경된 화면 확인
## http://worklog-frontend.myk8s.local

## (방법 2: yaml 수정 후 apply — AI가 이미지 태그 교체 후 적용)
## kubectl apply -f ./worklog_manifests/worklog-frontend.yaml

## 전체 정리
kubectl delete -f ~/_Lecture_cicd_learning.kit/ch3/3.6/worklog_manifests
