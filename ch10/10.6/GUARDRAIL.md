# GUARDRAIL: 10.6 [Jenkins] 기존 파이프라인을 EKS로 전환하기

## 범위 (Scope)
### 이 단계에서 다루는 것
- Jenkins 파이프라인에서 AWS EKS로 직접 배포 (kubectl)
- Jenkins Credentials를 이용한 AWS 인증
- Jenkins 파이프라인에서 Argo CD CLI를 통한 EKS 배포
- 이미지 빌드 후 manifest의 이미지 태그 업데이트 및 Git push
- Argo CD 동기화 및 헬스체크 대기

### 이 단계에서 다루지 않는 것
- GitHub Actions 파이프라인 (10.5에서 다룸)
- GitLab 파이프라인 (10.7에서 다룸)
- Argo CD 설치 (10.4에서 이미 완료)
- EKS 클러스터 생성 (10.4에서 완료)

## 사전 조건 (Prerequisites)
- ch10/10.4 완료 (EKS 클러스터 생성, kubectl 연결, Argo CD 설치)
- ch5 완료 (Jenkins 파이프라인 기본 이해)
- Jenkins Credentials 설정: `dockerhub-token`, `aws-access-key-id`, `aws-secret-access-key`, `argocd-admin-password`
- Jenkins 에이전트에 AWS CLI, kubectl, argocd CLI 설치

## 순서 (Sequence)

### Part A: Jenkins EKS 직접 배포

#### Step 1: Jenkins Credentials 설정 (AWS)
- Dashboard > Jenkins 관리 > Credentials > Global credentials
- `aws-access-key-id`, `aws-secret-access-key`, `eks-cluster-name` 등록
- 기대 결과: AWS 관련 Credentials 등록 완료

#### Step 2: EKS 배포 파이프라인 적용
- 명령어: `cp ~/_Lecture_cicd_learning.kit/ch10/10.6/1.eks-deploy-pipeline.groovy ~/workspace/worklog-backend/Jenkinsfile`
- 기대 결과: Jenkinsfile 업데이트

#### Step 3: Git push
- 명령어: `git add . && git commit -m "cicd: deploy to EKS via Jenkins" && git push origin main`
- 기대 결과: Jenkins 빌드 트리거 (또는 수동 Build Now)

#### Step 4: 배포 확인
- 명령어: `kubectl get pods` (EKS 컨텍스트)
- 기대 결과: worklog-backend Pod가 Running 상태

### Part B: Jenkins + Argo CD 연동 배포

#### Step 5: Argo CD Credentials 추가
- Jenkins > Credentials > argocd-admin-password 추가
- 기대 결과: Argo CD admin 비밀번호 등록

#### Step 6: Argo CD 파이프라인 적용
- 명령어: `cp ~/_Lecture_cicd_learning.kit/ch10/10.6/2.eks-argocd-pipeline.groovy ~/workspace/worklog-backend/Jenkinsfile`
- 기대 결과: Jenkinsfile 업데이트

#### Step 7: Git push
- 명령어: `git add . && git commit -m "cicd: EKS + Argo CD Jenkins pipeline" && git push origin main`
- 기대 결과: Jenkins 빌드 트리거

#### Step 8: Argo CD 동기화 확인
- Argo CD UI에서 Application 상태 확인
- 기대 결과: Synced/Healthy 상태

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| EKS 파이프라인 | Jenkins 빌드 콘솔 | 모든 stage 성공 |
| AWS 인증 | Configure AWS stage 로그 | kubeconfig 업데이트 성공 |
| EKS 배포 | `kubectl get pods` | worklog-backend Running |
| 서비스 | `kubectl get svc` | 서비스 엔드포인트 확인 |
| Argo CD 파이프라인 | Jenkins 빌드 콘솔 | 모든 stage 성공 |
| Manifest 업데이트 | Git 저장소 deploy_manifest 확인 | 새 이미지 태그로 업데이트 |
| Argo CD | Argo CD UI 또는 `argocd app get worklog-backend` | Synced/Healthy |
| Pod | `kubectl get pods` | 새 이미지로 Running |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| `<dockerhub_username>` | Docker Hub 사용자명 | ❌ 반드시 수강생에게 확인 필요 |

## 주의사항 (Cautions)
- ⛔ AWS 자격증명을 Jenkinsfile에 하드코딩하지 말 것 — Jenkins Credentials 사용
- ⛔ `ARGOCD_ADMIN_PASSWORD`를 Jenkinsfile에 하드코딩하지 말 것 — Jenkins Credentials 사용
- ⛔ `<dockerhub_username>`을 임의로 채우지 말 것
- ✅ Jenkins 에이전트에 AWS CLI, kubectl, argocd CLI가 설치되어 있어야 함
- ✅ `kubectl rollout status`로 배포 완료 대기
- ✅ `argocd app wait`로 헬스체크 완료까지 대기하여 파이프라인 신뢰성 확보
