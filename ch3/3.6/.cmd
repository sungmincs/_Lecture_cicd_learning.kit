# Kubernetes에 Worklog 앱 배포하기

## NGINX Gateway의 외부 IP 확인 (NGINX Gateway Fabric 사용)
kubectl get gateway nginx-gateway -o wide
## ADDRESS 컬럼의 IP를 다음 단계 hosts 파일에 사용

## hosts 파일 등록 (맥: /etc/hosts, 윈도우: C:\Windows\System32\drivers\etc\hosts)
## 아래 두 줄 추가 (192.168.x.x는 위 명령에서 확인한 EXTERNAL-IP)
# 192.168.1.99 worklog-frontend.myk8s.local
# 192.168.1.99 worklog-backend.myk8s.local

## Worklog 앱 배포
cd ~/_Lecture_cicd_learning.kit/ch3/3.6
kubectl apply -f ./worklog_manifests

## Pod 상태 확인
kubectl get pods -w

## 서비스 확인
kubectl get svc

## 앱 접속 확인 (브라우저)
## http://worklog-frontend.myk8s.local
## http://worklog-backend.myk8s.local/docs

## 데이터 입력 후 조회 테스트
## (UI에서 worklog 항목 추가 후 새로고침으로 확인)
