# GUARDRAIL: 8.5 [GitHub] Full CI/CD workflow (Argo CD)

## 범위 (Scope)
### 이 단계에서 다루는 것
- GitHub Actions + Argo CD를 결합한 완전한 CI/CD 워크플로우
- 환경별 Argo CD Application 생성 (dev, staging, prod)
- 이미지 빌드 후 manifest 자동 업데이트 → Argo CD 자동 동기화
- PR → develop → release → tag 전체 배포 흐름 실습

### 이 단계에서 다루지 않는 것
- Jenkins / GitLab 기반 워크플로우 (8.6~8.7, 8.8~8.9에서 다룸)
- Argo CD ApplicationSet을 이용한 동적 환경 생성
- Argo Rollouts를 이용한 카나리/블루그린 배포 (ch7에서 다룸)

## 사전 조건 (Prerequisites)
- ch8/8.4 완료 (멀티 환경 파이프라인 기본 이해)
- ch6 완료 (Argo CD 설치 및 설정)
- GitHub Secrets 등록: DOCKERHUB_TOKEN, CP_K8S_CONTEXT, ARGOCD_ADMIN_PASSWORD

## 순서 (Sequence)
### Step 1: Full CI/CD 파이프라인 파일 복사 [학습자 직접]
- 명령어: `cp ~/_Lecture_cicd_learning.kit/ch8/8.5/1.full-cicd-workflow.yaml .github/workflows/full-cicd-workflow.yaml`
- 기대 결과: `.github/workflows/` 디렉토리에 파이프라인 파일 생성

### Step 2: YAML 파일에서 플레이스홀더 수정 [AI 프롬프트]
- `<dockerhub_username>`을 본인 Docker Hub 사용자 이름으로 변경
- 기대 결과: env.DOCKER_REPOSITORY, env.DOCKERHUB_USERNAME 값이 올바르게 설정됨

### Step 3: 코드 커밋 및 푸시 [학습자 직접]
- 명령어: `git add . && git commit -m "cicd: full CI/CD workflow with Argo CD" && git push origin main`
- 기대 결과: GitHub Actions 트리거

### Step 4: Argo CD Application 생성 [AI 프롬프트]
- 명령어: `kubectl apply -f ~/_Lecture_cicd_learning.kit/ch8/8.5/2.argocd-apps-multi-env.yaml`
- `<github_username>` 플레이스홀더를 사전에 수정
- 기대 결과: argocd namespace에 3개 Application 생성

### Step 5: 전체 흐름 테스트 [학습자 직접]
- develop push → dev 배포 확인
- PR 생성 → dev preview 배포 확인
- release/* push → staging 배포 확인
- tag 생성 → prod 배포 확인
- 기대 결과: 각 환경에 올바른 이미지가 배포됨

### Step 6: Argo CD UI 및 CLI 확인 [학습자 직접]
- 명령어: `argocd app list`
- 기대 결과: worklog-backend-dev, worklog-backend-staging, worklog-backend-prod 모두 Healthy/Synced

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| Argo CD App 생성 | `argocd app list` | 3개 Application 존재 |
| dev 배포 | `kubectl get pods -n dev` | worklog-backend Pod Running |
| staging 배포 | `kubectl get pods -n staging` | worklog-backend Pod Running |
| prod 배포 | `kubectl get pods -n prod` | worklog-backend Pod Running |
| Argo CD 상태 | Argo CD UI 확인 | 모든 App이 Healthy/Synced |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| `<dockerhub_username>` | Docker Hub 사용자 이름 | ❌ 반드시 확인 필요 |
| `<github_username>` | GitHub 사용자 이름 | ❌ 반드시 확인 필요 |
| `ARGOCD_ADMIN_PASSWORD` | Argo CD 관리자 비밀번호 (GitHub Secret) | ❌ 반드시 확인 필요 |

## 주의사항 (Cautions)
- ⛔ 2.argocd-apps-multi-env.yaml의 `<github_username>`을 반드시 수정한 후 apply 해야 한다.
- ⛔ update-manifest job에서 git push가 실패하면 배포가 진행되지 않는다. GITHUB_TOKEN 권한을 확인한다.
- ⛔ Argo CD Application의 targetRevision이 실제 브랜치 이름과 일치해야 한다.
- ✅ Argo CD의 automated syncPolicy가 설정되어 있으므로 manifest 변경 시 자동 배포된다.
- ✅ 배포 실패 시 Argo CD UI에서 상세 에러 로그를 확인할 수 있다.
