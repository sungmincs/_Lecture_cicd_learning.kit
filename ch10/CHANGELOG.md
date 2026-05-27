# ch10 변경 이력 및 설계 결정

## [2026-05] 코드 레벨 검증 완료

### 검증 범위

ch10은 AWS EKS + Terraform이라 **실제 AWS 검증은 비용/계정 책임 영역**으로 인해 sungmin이 직접 진행합니다. 강의 키트 단계에서는 **코드 레벨만 검증**했습니다.

| 항목 | 검증 결과 | 비고 |
|---|---|---|
| Terraform `terraform-eks/` validate | ✅ | syntax OK |
| Terraform `terraform-test/` validate | ✅ | syntax OK |
| GitHub Actions yaml (10.5 × 2) | ✅ | yaml.safe_load OK |
| Jenkins Groovy (10.6 × 2) | ✅ | brace balanced |
| GitLab CI yaml (10.7 × 2) | ✅ | GitLab CI lint API valid:True |

### 파이프라인 6개 코드 수정 [2026-05-26]

**공통 변경:**
- `poetry` → `uv` 전환 (의존성 일관성)
- `docker build` → `docker buildx --platform linux/amd64,linux/arm64 --push` (Apple Silicon 호환)
- ch9 검증 중 발견된 Jenkins/GitLab CI 제약사항 적용

**파일별 변경:**

| 파일 | 주요 변경 |
|---|---|
| `10.5/1.eks-deploy-pipeline.yaml` | setup-uv@v5, buildx multi-platform. `aws eks update-kubeconfig` + `kubectl apply` 유지 (EKS 외부 접근 가능) |
| `10.5/2.eks-argocd-pipeline.yaml` | 동일 + Argo CD GitOps 패턴 |
| `10.6/1.eks-deploy-pipeline.groovy` | curl uv 설치, binfmt + buildx, `env.*` 통일, stage 내 agent 중복 제거 |
| `10.6/2.eks-argocd-pipeline.groovy` | 동일 + Update Manifest stage 추가 |
| `10.7/1.eks-deploy-pipeline.yml` | uv 이미지, DOCKER_HOST 2375, buildx multi-platform, `$DOCKER_REPOSITORY` 단독 사용 |
| `10.7/2.eks-argocd-pipeline.yml` | 동일 + Argo CD GitOps + `test allow_failure: true` |

### ch9에서 발견된 제약사항 적용

- Jenkins: 전역 `def` 변수 금지, `env.*` 환경변수만 사용
- Jenkins: stage 내 `agent any` 중복 지정 금지 (env 변수 손실)
- Jenkins: `git push origin HEAD:${env.BRANCH_NAME}` (Multibranch detached HEAD)
- GitLab CI: `DOCKER_REPOSITORY`에 이미 username 포함이므로 `$DOCKERHUB_USERNAME/$DOCKER_REPOSITORY` 형태 금지
- GitLab CI: test stage `allow_failure: true` (worklog-backend uv container 비동기 테스트 호환성 이슈)

### Terraform 코드 최신화 [2026-05-26]

> ⚠️ 최초 코드는 2024년 시점이라 EKS/Provider/모듈 모두 구버전. 2026년 5월 기준 최신화.

**변경 내역 (`ch10/10.3/terraform-eks/main.tf`):**

| 항목 | Before | After |
|---|---|---|
| Terraform required | `>= 1.0` | `>= 1.5.7` (EKS v21 요구) |
| AWS Provider | `~> 5.0` | `~> 6.0` (현재 6.46.0) |
| VPC 모듈 | `~> 5.0` | `~> 6.0` (현재 6.6.1) |
| EKS 모듈 | `~> 20.0` | `~> 21.0` (현재 21.22.0) |
| Kubernetes 버전 | `1.29` (EOL) | `1.36` (강의 권장) |
| AMI | (기본 AL2) | `AL2023_x86_64_STANDARD` 명시 |
| EKS Addons | ❌ 없음 | `coredns`, `kube-proxy`, `vpc-cni`, `aws-ebs-csi-driver` |
| Access 권한 | (별도 설정 필요) | `enable_cluster_creator_admin_permissions = true` |

**EKS 모듈 v21 변수명 변경 (Breaking Change):**
- `cluster_version` → `kubernetes_version`
- `cluster_addons` → `addons`
- `cluster_name` → `name`
- `cluster_endpoint_public_access` → `endpoint_public_access`
- `aws-auth` 서브모듈 제거 → `access_entries` 사용

**EBS CSI Driver IAM:**
- 별도 IRSA 모듈 제거 (v6 IAM 모듈에서 `iam-role-for-service-accounts-eks` 서브모듈 사라짐)
- EKS 모듈이 Pod Identity로 자동 처리 (v21 권장)

**Terraform syntax 검증:** `terraform validate` ✅ Success

---

## ⚠️ sungmin 검증 필요 영역

### AWS EKS 검증

다음은 강의 녹화 시점에 sungmin이 AWS 계정으로 직접 검증해야 합니다:

**10.2 AWS 환경 설정:**
- AWS CLI 설정
- IAM User/Role 생성
- Access Key/Secret 발급

**10.3 Terraform EKS 배포:**
- `terraform-test/`: AWS credentials 정상 동작 검증
- `terraform-eks/`: EKS 클러스터 + 노드 그룹 생성
- 비용 발생: EKS $0.10/시간 + 노드 EC2 비용

**10.4 EKS에 Worklog + Argo CD 배포:**
- `aws eks update-kubeconfig`
- worklog-backend 매니페스트 적용 (deploy_manifest 또는 ch3.4 기반)
- Argo CD Helm 설치

**10.5/10.6/10.7 파이프라인 실제 검증:**
- 각 도구에서 빌드/배포 동작 확인
- GitHub Secrets/Jenkins Credentials/GitLab Variables 설정 필요:
  - `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`, `EKS_CLUSTER_NAME`

### 비용 주의사항

- EKS 클러스터 시간당 $0.10
- 노드 그룹 EC2 (예: t3.medium × 2) 시간당 약 $0.10
- 실습 1회당 약 $1-3 예상
- **실습 후 즉시 `terraform destroy` 필수**

### 검증 권장 흐름

1. `terraform-test/` 먼저 검증 (AWS 연결 확인, 비용 ~$0)
2. `terraform-eks/` apply (15~20분 소요)
3. ArgoCD Helm 설치
4. 파이프라인 1개씩 검증 (10.5 → 10.6 → 10.7)
5. `terraform destroy` (10분 소요)
