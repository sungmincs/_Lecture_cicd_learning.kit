# GUARDRAIL: 10.3 Terraform을 이용한 EKS 배포와 삭제

## 범위 (Scope)
### 이 단계에서 다루는 것
- Terraform 설치 및 버전 확인
- Terraform 기본 개념 이해 (IaC, HCL, Provider, State)
- 간단한 Terraform 프로젝트로 AWS 연동 테스트
- Terraform 워크플로우: init > plan > apply
- Terraform으로 AWS VPC + EKS 클러스터 생성
- kubectl을 EKS 클러스터에 연결 (kubeconfig 업데이트)
- EKS 클러스터에 Ingress Controller 설치
- 실습 완료 후 terraform destroy로 리소스 정리

### 이 단계에서 다루지 않는 것
- CI/CD 파이프라인 배포 (10.4~10.7에서 다룸)
- Terraform Cloud / Remote State 관리
- Terraform 모듈 커스터마이징

## 사전 조건 (Prerequisites)
- ch10/10.2 완료 (AWS CLI 설치 및 자격증명 설정)
- `aws sts get-caller-identity` 정상 동작 확인

## 순서 (Sequence)
### Step 1: Terraform 설치
- 명령어: HashiCorp 저장소 추가 후 `apt install terraform -y`
- 기대 결과: Terraform 설치 완료

### Step 2: 버전 확인
- 명령어: `terraform version`
- 기대 결과: Terraform v1.x.x 출력

### Step 3: 테스트 프로젝트 생성 및 AWS 연동 테스트
- 명령어: `mkdir -p ~/terraform-test && cd ~/terraform-test`
- AWS caller identity를 조회하는 간단한 Terraform 코드 작성
- 명령어: `terraform init && terraform plan && terraform apply`
- 기대 결과: AWS 계정 ID가 output으로 출력

### Step 4: 테스트 정리
- 명령어: `rm -rf ~/terraform-test`
- 기대 결과: 테스트 디렉토리 삭제

### Step 5: EKS Terraform 디렉토리 이동
- 명령어: `cd ~/_Lecture_cicd_learning.kit/ch10/10.3/terraform-eks`
- 기대 결과: main.tf, variables.tf, outputs.tf 파일 존재

### Step 6: Terraform 초기화
- 명령어: `terraform init`
- 기대 결과: Provider 다운로드 및 모듈 초기화 성공

### Step 7: 실행 계획 확인
- 명령어: `terraform plan`
- 기대 결과: VPC, EKS 등 리소스 생성 계획 표시

### Step 8: EKS 클러스터 생성
- 명령어: `terraform apply -auto-approve`
- 기대 결과: 15~20분 후 클러스터 생성 완료, endpoint/name/region 출력

### Step 9: kubeconfig 업데이트
- 명령어: `aws eks update-kubeconfig --region ap-northeast-2 --name cicd-learning-eks`
- 기대 결과: kubectl이 EKS 클러스터를 대상으로 동작

### Step 10: 클러스터 확인
- 명령어: `kubectl get nodes`
- 기대 결과: 3개의 노드가 Ready 상태

### Step 11: Ingress Controller 설치
- 명령어: `kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.10.0/deploy/static/provider/aws/deploy.yaml`
- 기대 결과: ingress-nginx 네임스페이스에 서비스 생성

### Step 12: (실습 완료 후) 리소스 정리
- 명령어: `terraform destroy -auto-approve`
- 기대 결과: 모든 AWS 리소스 삭제

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| 설치 | `terraform version` | Terraform v1.x.x 출력 |
| AWS 테스트 | `terraform apply` (test project) | account_id 출력 |
| EKS init | `terraform init` | Terraform has been successfully initialized |
| EKS 생성 | `terraform apply` | Apply complete! Resources: N added |
| kubeconfig | `kubectl get nodes` | 3개 노드 Ready |
| Ingress | `kubectl get svc -n ingress-nginx` | LoadBalancer 타입 서비스 생성 |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| 없음 | AWS 자격증명은 10.2에서 이미 설정됨 | - |

## 주의사항 (Cautions)
- ⛔ `terraform apply`는 실제 AWS 리소스를 생성하며 비용이 발생함 — t3.medium 3대 + NAT Gateway + EKS 제어 플레인
- ⛔ 실습 완료 후 반드시 `terraform destroy`를 실행하여 비용 발생 방지
- ⛔ Terraform state 파일(`.tfstate`)을 git에 커밋하지 말 것
- ✅ `terraform plan`으로 변경사항을 먼저 확인한 후 `apply` 실행
- ✅ 클러스터 생성에 15~20분 소요되므로 인내심을 가지고 대기
