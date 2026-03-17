# GUARDRAIL: 10.2 AWS 환경 설정하기

## 범위 (Scope)
### 이 단계에서 다루는 것
- 로컬 K8s 환경(Vagrant + VirtualBox)과 클라우드 EKS 환경의 구조적 차이 이해
- 네트워킹, 스토리지, 보안, 스케일링 관점의 비교
- 현재 로컬 환경의 구성 확인
- AWS CLI 설치 및 버전 확인
- AWS 자격증명 설정 (aws configure)
- AWS 연결 확인 (aws sts get-caller-identity)
- eksctl 설치 (선택사항)

### 이 단계에서 다루지 않는 것
- AWS 계정 생성 (사전에 준비 필요)
- IAM 사용자 생성 및 권한 설정 (사전에 준비 필요)
- Terraform 설치 및 EKS 클러스터 생성 (10.3에서 다룸)
- EKS 공통 배포 (10.4에서 다룸)
- 도구별 파이프라인 구성 (10.5~10.7에서 다룸)

## 사전 조건 (Prerequisites)
- ch2 완료 (로컬 K8s 환경 구성 경험)
- 로컬 K8s 클러스터가 동작 중인 상태
- AWS 계정 보유
- IAM 사용자 생성 완료 (AdministratorAccess 또는 EKS 관련 권한)
- Access Key ID / Secret Access Key 발급 완료

## 순서 (Sequence)

### Part A: 로컬 vs 클라우드 환경 차이 이해

#### Step 1: 로컬 환경 확인
- 명령어: `kubectl get nodes`
- 기대 결과: 로컬 K8s 노드 목록 출력

#### Step 2: 클러스터 정보 확인
- 명령어: `kubectl cluster-info`
- 기대 결과: 로컬 클러스터 API 서버 주소 및 서비스 정보 출력

#### Step 3: 차이점 학습
- 이론 학습: 네트워킹, 스토리지, 보안, 스케일링 관점의 차이
- 기대 결과: 로컬과 클라우드 환경의 핵심 차이를 이해

### Part B: AWS CLI 설치 및 설정

#### Step 4: AWS CLI 설치
- 명령어: `curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip && ./aws/install`
- 기대 결과: AWS CLI v2 설치 완료

#### Step 5: AWS CLI 버전 확인
- 명령어: `aws --version`
- 기대 결과: `aws-cli/2.x.x` 출력

#### Step 6: AWS 자격증명 설정
- 명령어: `aws configure`
- 기대 결과: `~/.aws/credentials` 및 `~/.aws/config` 파일 생성

#### Step 7: AWS 연결 확인
- 명령어: `aws sts get-caller-identity`
- 기대 결과: Account, UserId, Arn 정보가 JSON으로 출력

#### Step 8: eksctl 설치 (선택)
- 명령어: `curl --silent --location "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp && mv /tmp/eksctl /usr/local/bin`
- 기대 결과: `eksctl version` 명령어 정상 출력

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| 로컬 환경 | `kubectl get nodes` | 노드 목록이 정상 출력 |
| 클러스터 정보 | `kubectl cluster-info` | API 서버 주소 확인 |
| AWS CLI | `aws --version` | aws-cli/2.x.x 출력 |
| 자격증명 | `aws sts get-caller-identity` | Account/UserId/Arn JSON 출력 |
| eksctl | `eksctl version` | 버전 정보 출력 |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| `<aws_access_key_id>` | AWS Access Key ID | ❌ 절대 임의로 채우지 말 것 |
| `<aws_secret_access_key>` | AWS Secret Access Key | ❌ 절대 임의로 채우지 말 것 |

## 주의사항 (Cautions)
- ✅ Part A는 이론 중심이므로 별도의 리소스 생성이 없음
- ✅ 로컬 환경과 클라우드 환경의 차이를 충분히 이해한 후 Part B로 진행
- ⛔ AWS 자격증명(Access Key, Secret Key)은 절대 git에 커밋하지 말 것
- ⛔ `<aws_access_key_id>`, `<aws_secret_access_key>`를 임의로 채우지 말 것 — 반드시 수강생 본인의 값 사용
- ✅ `aws sts get-caller-identity`로 정상 연결 확인 후 다음 단계(10.3 Terraform EKS)로 진행
- ✅ `.gitignore`에 `~/.aws/` 관련 파일이 포함되지 않도록 주의
