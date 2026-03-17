# GUARDRAIL: 10.5 [GitHub] 기존 파이프라인을 EKS로 전환하기

## 범위 (Scope)
### 이 단계에서 다루는 것
- GitHub Actions 파이프라인에서 AWS EKS로 직접 배포
- aws-actions/configure-aws-credentials를 이용한 AWS 인증
- kubectl을 통한 EKS 클러스터 배포
- GitHub Actions 파이프라인에서 Argo CD CLI를 통한 동기화
- 이미지 태그 업데이트 후 Git push > Argo CD sync 워크플로우

### 이 단계에서 다루지 않는 것
- Jenkins 파이프라인 (10.6에서 다룸)
- GitLab 파이프라인 (10.7에서 다룸)
- EKS 클러스터 생성 및 Argo CD 설치 (10.4에서 완료)

## 사전 조건 (Prerequisites)
- ch10/10.4 완료 (EKS 클러스터 생성, kubectl 연결, Argo CD 설치 및 LoadBalancer 노출)
- ch5 완료 (GitHub Actions 기본 파이프라인 이해)
- GitHub Secrets 설정: `DOCKERHUB_TOKEN`, `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`, `EKS_CLUSTER_NAME`, `ARGOCD_ADMIN_PASSWORD`

## 순서 (Sequence)

### Part A: EKS 직접 배포 파이프라인

#### Step 1: GitHub Secrets 설정
- GitHub 저장소 > Settings > Secrets and variables > Actions
- 기대 결과: AWS 관련 시크릿 5개 등록 완료 (`DOCKERHUB_TOKEN`, `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`, `EKS_CLUSTER_NAME`)

#### Step 2: 파이프라인 파일 복사
- 명령어: `cp ~/_Lecture_cicd_learning.kit/ch10/10.5/1.eks-deploy-pipeline.yaml ~/workspace/worklog-backend/.github/workflows/eks-deploy.yaml`
- 기대 결과: workflow 파일 복사 완료

#### Step 3: Git push
- 명령어: `git add . && git commit -m "cicd: deploy to EKS via GitHub Actions" && git push origin main`
- 기대 결과: GitHub Actions 파이프라인 자동 트리거

#### Step 4: 배포 확인
- 명령어: `kubectl get pods` (EKS 컨텍스트)
- 기대 결과: worklog-backend Pod가 Running 상태

### Part B: Argo CD 연동 파이프라인

#### Step 5: GitHub Secrets 추가
- `ARGOCD_ADMIN_PASSWORD` 시크릿 추가
- 기대 결과: Argo CD 관련 시크릿 등록 완료

#### Step 6: 파이프라인 파일 복사 및 push
- 명령어: `cp ~/_Lecture_cicd_learning.kit/ch10/10.5/2.eks-argocd-pipeline.yaml ~/workspace/worklog-backend/.github/workflows/eks-argocd.yaml`
- 기대 결과: workflow 파일 복사 완료

#### Step 7: Git push
- 명령어: `git add . && git commit -m "cicd: EKS + Argo CD pipeline via GitHub Actions" && git push origin main`
- 기대 결과: GitHub Actions 파이프라인 자동 트리거

#### Step 8: 배포 확인
- Argo CD UI에서 Application 상태 확인
- 기대 결과: Synced/Healthy 상태

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| EKS 직접 배포 파이프라인 | GitHub Actions UI | 모든 job 성공 (녹색 체크) |
| AWS 인증 | deploy job 로그 | kubeconfig 업데이트 성공 |
| 배포 | `kubectl get pods` | worklog-backend Running |
| 서비스 | `kubectl get svc` | 서비스 엔드포인트 확인 |
| Argo CD 파이프라인 | GitHub Actions UI | 모든 job 성공 |
| Argo CD 동기화 | Argo CD UI 또는 `argocd app get worklog-backend` | Synced/Healthy |
| Pod | `kubectl get pods` | 새 이미지로 Running |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| `<dockerhub_username>` | Docker Hub 사용자명 | ❌ 반드시 수강생에게 확인 필요 |

## 주의사항 (Cautions)
- ⛔ AWS 자격증명을 파이프라인 파일에 하드코딩하지 말 것 — GitHub Secrets 사용
- ⛔ `ARGOCD_ADMIN_PASSWORD`를 파이프라인 파일에 하드코딩하지 말 것 — GitHub Secrets 사용
- ⛔ `<dockerhub_username>`을 임의로 채우지 말 것
- ✅ deploy job에서 `aws-actions/configure-aws-credentials@v4` 액션으로 안전하게 인증
- ✅ `kubectl rollout status`로 배포 완료 대기
- ✅ deploy 단계에서 manifest를 업데이트하고 push하면 Argo CD가 자동 감지
- ✅ `argocd app wait`로 헬스체크 완료까지 대기하여 파이프라인 신뢰성 확보
