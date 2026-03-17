# GUARDRAIL: 10.7 [GitLab] 기존 파이프라인을 EKS로 전환하기

## 범위 (Scope)
### 이 단계에서 다루는 것
- GitLab CI/CD에서 AWS EKS 클러스터로 직접 배포하는 파이프라인 구현
- GitLab CI/CD Variables에 AWS 자격증명 설정
- AWS CLI + kubectl을 사용한 EKS 배포
- GitLab CI/CD + Argo CD를 결합한 EKS 배포 파이프라인 구현
- 빌드 후 Argo CD CLI로 EKS에 GitOps 기반 배포

### 이 단계에서 다루지 않는 것
- GitHub Actions EKS 배포 / Argo CD 연동 (10.5에서 다룸)
- Jenkins EKS 배포 / Argo CD 연동 (10.6에서 다룸)
- EKS 클러스터 생성 (ch10/10.4에서 완료)
- Argo CD 설치 (ch10/10.4에서 완료)

## 사전 조건 (Prerequisites)
- ch10/10.4 완료 — EKS 클러스터 생성, kubectl 접근 확인, Argo CD 설치 완료
- ch5 완료 — GitLab CI/CD 파이프라인 이해
- GitLab CI/CD Variables: AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_REGION, EKS_CLUSTER_NAME
- DOCKERHUB_USERNAME, DOCKERHUB_TOKEN 설정 완료
- ⚠️ EKS 미생성 시 ch10/10.4로 돌아갈 것
- ⚠️ Argo CD 미설치 시 ch10/10.4로 돌아갈 것

## 순서 (Sequence)

### Part A: EKS 직접 배포 파이프라인

#### Step 1: GitLab CI/CD Variables에 AWS 자격증명 추가
- 경로: Settings → CI/CD → Variables
- 기대 결과: AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY (Masked), AWS_REGION, EKS_CLUSTER_NAME 등록

#### Step 2: EKS 배포 파이프라인 적용
- 명령어: `cp ~/_Lecture_cicd_learning.kit/ch10/10.7/1.eks-deploy-pipeline.yml .gitlab-ci.yml`
- 기대 결과: .gitlab-ci.yml이 EKS 배포용으로 업데이트

#### Step 3: push하여 파이프라인 실행
- 명령어: `git add . && git commit -m "cicd: deploy to EKS via GitLab" && git push origin main`
- 기대 결과: GitLab Pipelines에서 build → deploy 성공

#### Step 4: EKS에서 배포 확인
- 명령어: `kubectl get pods` / `kubectl get svc`
- 기대 결과: EKS 클러스터에 worklog-backend pod 실행 중

### Part B: Argo CD 연동 파이프라인

#### Step 5: GitLab CI/CD Variables에 Argo CD 접속 정보 추가
- 경로: Settings → CI/CD → Variables
- 기대 결과: ARGOCD_SERVER, ARGOCD_PASSWORD 등록

#### Step 6: Argo CD 파이프라인 적용
- 명령어: `cp ~/_Lecture_cicd_learning.kit/ch10/10.7/2.eks-argocd-pipeline.yml .gitlab-ci.yml`
- 기대 결과: .gitlab-ci.yml이 Argo CD 연동 버전으로 업데이트

#### Step 7: push하여 파이프라인 실행
- 명령어: `git add . && git commit -m "cicd: EKS + Argo CD GitLab pipeline" && git push origin main`
- 기대 결과: GitLab Pipelines에서 build → deploy(Argo CD sync) 성공

#### Step 8: Argo CD에서 동기화 확인
- 명령어: `argocd app list`
- 기대 결과: worklog-backend 앱이 Synced, Healthy 상태

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| Variables 설정 (AWS) | GitLab CI/CD Variables 페이지 | AWS 관련 4개 변수 존재 |
| EKS 직접 배포 파이프라인 | GitLab Pipelines | build, deploy 모두 성공 |
| EKS 배포 | `kubectl get pods` | worklog-backend pod Running |
| Variables 설정 (Argo CD) | GitLab CI/CD Variables 페이지 | ARGOCD_SERVER, ARGOCD_PASSWORD 존재 |
| Argo CD 파이프라인 | GitLab Pipelines | build, deploy 모두 성공 |
| Argo CD 동기화 | `argocd app list` | worklog-backend Synced + Healthy |
| 최종 EKS 확인 | `kubectl get pods` | 최신 이미지로 pod 실행 중 |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| AWS_ACCESS_KEY_ID | AWS 액세스 키 | ❌ 절대 임의로 채우지 말 것 |
| AWS_SECRET_ACCESS_KEY | AWS 시크릿 키 | ❌ 절대 임의로 채우지 말 것 |
| ARGOCD_SERVER | Argo CD 서버 URL (EKS LoadBalancer IP) | ❌ 반드시 수강생에게 확인 |
| ARGOCD_PASSWORD | Argo CD admin 비밀번호 | ❌ 반드시 수강생에게 확인 |

## 주의사항 (Cautions)
- ⛔ AI가 하지 말아야 할 것: AWS 자격증명을 .gitlab-ci.yml에 하드코딩하지 말 것
- ⛔ AI가 하지 말아야 할 것: Argo CD 비밀번호를 .gitlab-ci.yml에 하드코딩하지 말 것
- ⛔ AI가 하지 말아야 할 것: EKS 클러스터가 없는 상태에서 배포를 진행하지 말 것
- ⛔ AI가 하지 말아야 할 것: 실습 완료 후 `terraform destroy` 안내를 빠뜨리지 말 것 (비용 발생)
- ✅ AI가 해도 되는 것: AWS CLI + EKS kubeconfig 설정 과정 설명
- ✅ AI가 해도 되는 것: 로컬 K8s 배포와 EKS 배포의 차이점 설명
- ✅ AI가 해도 되는 것: 전체 CI/CD 파이프라인 흐름 요약 설명
