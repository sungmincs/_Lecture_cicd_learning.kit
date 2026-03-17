# GUARDRAIL: 6.6 [GitHub] Argo CD 적용해 파이프라인 구현하기

## 범위 (Scope)
### 이 단계에서 다루는 것
- GitHub Actions 파이프라인에서 kubectl deploy를 Argo CD sync로 교체
- 이미지 빌드 후 manifest의 이미지 태그 업데이트 및 Git push
- Argo CD CLI를 통한 동기화 및 헬스체크 대기

### 이 단계에서 다루지 않는 것
- Jenkins 파이프라인 (6.7에서 다룸)
- GitLab 파이프라인 (6.8에서 다룸)
- Argo CD 설치 및 Application 생성 (6.2~6.4에서 완료)

## 사전 조건 (Prerequisites)
- ch5/5.2 또는 5.3 완료 (GitHub Actions 파이프라인 기본 구성)
- ch6/6.4 완료 (Argo CD Application 등록)
- GitHub Secrets 설정: `DOCKERHUB_TOKEN`, `ARGOCD_ADMIN_PASSWORD`

## 순서 (Sequence)
### Step 1: 파이프라인 파일 복사
- 명령어: `cp ~/_Lecture_cicd_learning.kit/ch6/6.6/1.build-and-argocd-sync.yaml ~/workspace/worklog-backend/.github/workflows/build-and-argocd-sync.yaml`
- 기대 결과: workflow 파일 복사 완료

### Step 2: Git push
- 명령어: `git add . && git commit -m "cicd: integrate Argo CD sync in pipeline" && git push origin main`
- 기대 결과: GitHub Actions 파이프라인 자동 트리거

### Step 3: 파이프라인 실행 확인
- GitHub Actions UI에서 워크플로우 실행 확인
- 기대 결과: init-and-test > build > deploy 순서로 성공

### Step 4: Argo CD 동기화 확인
- Argo CD UI에서 Application 상태 확인
- 기대 결과: Synced/Healthy 상태

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| 파이프라인 | GitHub Actions UI | 모든 job 성공 (녹색 체크) |
| 이미지 태그 | deploy_manifest/worklog-backend.yaml 확인 | 새 이미지 태그로 업데이트됨 |
| Argo CD | `argocd app get worklog-backend` | Synced/Healthy |
| Pod | `kubectl get pods` | 새 이미지로 Running |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| `<dockerhub_username>` | Docker Hub 사용자명 | ❌ 반드시 수강생에게 확인 필요 |

## 주의사항 (Cautions)
- ⛔ `ARGOCD_ADMIN_PASSWORD`를 파이프라인 파일에 하드코딩하지 말 것 — GitHub Secrets 사용
- ⛔ `<dockerhub_username>`을 임의로 채우지 말 것
- ✅ deploy 단계에서 manifest를 업데이트하고 push하면 Argo CD가 자동 감지
- ✅ `argocd app wait`로 헬스체크 완료까지 대기하여 파이프라인 신뢰성 확보
