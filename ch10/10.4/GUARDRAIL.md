# GUARDRAIL: 10.4 [공통] EKS에 Worklog App과 Argo CD 배포하기

## Scope
- kubectl로 Worklog App을 EKS에 수동 배포
- Argo CD를 EKS에 설치
- Argo CD UI 접속 확인

## Not Covered
- CI/CD 파이프라인을 통한 자동 배포 (10.5~10.7에서 다룸)

## Prerequisites
- ch10/10.3 완료 (EKS 클러스터 생성)
- ch8 완료 (Worklog App 매니페스트 이해)

## Sequence
1. kubectl로 Worklog App 배포 (mongodb, backend, frontend manifests from ch8)
2. 서비스 확인 (kubectl get pods, svc, ingress)
3. Argo CD 설치 (kubectl create namespace argocd, apply manifest)
4. Argo CD LoadBalancer로 노출
5. Argo CD 초기 비밀번호 확인 및 UI 접속

## Placeholders
- none

## Cautions
- EKS Ingress는 AWS ALB 사용으로 로컬과 다름
- Argo CD는 LoadBalancer로 노출
