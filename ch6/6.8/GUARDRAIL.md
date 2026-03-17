# GUARDRAIL: 6.8 [GitLab] Argo CD 적용해 파이프라인 구현하기

## 범위 (Scope)
### 이 단계에서 다루는 것
- GitLab CI/CD 파이프라인에서 kubectl deploy를 Argo CD sync로 교체
- .gitlab-ci.yml에 manifest 업데이트 및 Argo CD 동기화 스테이지 추가
- GitLab CI/CD Variables를 통한 Argo CD 인증

### 이 단계에서 다루지 않는 것
- GitHub Actions 파이프라인 (6.6에서 다룸)
- Jenkins 파이프라인 (6.7에서 다룸)
- Argo CD 설치 및 Application 생성 (6.2~6.4에서 완료)

## 사전 조건 (Prerequisites)
- ch5/5.6 또는 5.7 완료 (GitLab CI/CD 파이프라인 기본 구성)
- ch6/6.4 완료 (Argo CD Application 등록)
- GitLab CI/CD Variables 설정: `DOCKERHUB_USERNAME`, `DOCKERHUB_TOKEN`, `ARGOCD_ADMIN_PASSWORD`

## 순서 (Sequence)
### Step 1: .gitlab-ci.yml 복사
- 명령어: `cp ~/_Lecture_cicd_learning.kit/ch6/6.8/1.build-and-argocd-sync.yml .gitlab-ci.yml`
- 기대 결과: .gitlab-ci.yml 업데이트

### Step 2: Git push
- 명령어: `git add . && git commit -m "cicd: integrate Argo CD sync in pipeline" && git push origin main`
- 기대 결과: GitLab CI/CD 파이프라인 자동 트리거

### Step 3: 파이프라인 실행 확인
- GitLab CI/CD > Pipelines에서 실행 확인
- 기대 결과: init > test > build > deploy > notify 순서로 성공

### Step 4: Argo CD 동기화 확인
- Argo CD UI에서 Application 상태 확인
- 기대 결과: Synced/Healthy 상태

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| 파이프라인 | GitLab Pipelines UI | 모든 stage 성공 (녹색) |
| 이미지 태그 | deploy_manifest/worklog-backend.yaml 확인 | 새 이미지 태그로 업데이트됨 |
| Argo CD | `argocd app get worklog-backend` | Synced/Healthy |
| Pod | `kubectl get pods` | 새 이미지로 Running |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| `<dockerhub_username>` | Docker Hub 사용자명 | ❌ 반드시 수강생에게 확인 필요 |

## 주의사항 (Cautions)
- ⛔ Argo CD 비밀번호를 .gitlab-ci.yml에 하드코딩하지 말 것 — GitLab CI/CD Variables 사용
- ⛔ `<dockerhub_username>`을 임의로 채우지 말 것
- ✅ deploy-argocd 스테이지에서 argocd CLI를 alpine 이미지에 설치하여 사용
- ✅ GitLab에서 Git push를 위해 적절한 deploy token 또는 SSH key 설정 필요
- ✅ worklog-backend-gitlab 저장소에서 작업 (GitHub 저장소와 별도)
