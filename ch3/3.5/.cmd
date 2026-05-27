# CI/CD 관점으로 Kubernetes 오브젝트 재이해하기

## 배포 매니페스트 구조 확인
cat ~/_Lecture_cicd_learning.kit/ch3/3.6/worklog_manifests/worklog-backend.yaml
cat ~/_Lecture_cicd_learning.kit/ch3/3.6/worklog_manifests/worklog-mongodb.yaml

## 핵심 질문 1: 왜 Deployment인가?
## → 이미지 태그를 바꾸면 배포가 일어난다
# kubectl set image는 CI/CD 파이프라인이 "배포"를 트리거하는 핵심 명령
# kubectl set image deployment/worklog-backend worklog-backend=<dockerhub_username>/worklog-backend:buildtest2

## 핵심 질문 2: 왜 Secret인가?
## → 파이프라인 로그에 DB 비밀번호가 찍히면 안 된다
# Secret에 저장된 값 확인 (base64 디코딩)
echo "cm9vdA==" | base64 -d   # username: root
echo "bXlwYXNzdzByZA==" | base64 -d   # password: mypassw0rd

## 핵심 질문 3: 왜 imagePullSecrets인가?
## → Docker Hub rate limit + private registry 접근
# kubectl create secret docker-registry dockerhub-creds \
#   --docker-username=<dockerhub_username> \
#   --docker-password=<dockerhub_password>
