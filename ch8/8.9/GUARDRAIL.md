# GUARDRAIL: 8.9 [GitLab] Full CI/CD workflow (Argo CD)

## 범위 (Scope)
### 이 단계에서 다루는 것
- GitLab CI/CD + Argo CD를 결합한 완전한 CI/CD 워크플로우
- Branch/Tag 기반 환경 판별 후 Argo CD를 통한 배포
- argocd CLI를 사용한 app set, sync, wait 자동화
- GitLab CI/CD Variables를 통한 Argo CD 인증 관리

### 이 단계에서 다루지 않는 것
- GitHub Actions / Jenkins 기반 워크플로우 (8.4~8.5, 8.6~8.7에서 다룸)
- Argo CD ApplicationSet을 이용한 동적 환경 생성
- Argo Rollouts를 이용한 카나리/블루그린 배포 (ch7에서 다룸)
- GitLab environments를 이용한 배포 추적

## 사전 조건 (Prerequisites)
- ch8/8.8 완료 (GitLab 멀티 환경 파이프라인 기본 이해)
- ch6 완료 (Argo CD 설치 및 설정)
- ch8/8.5 완료 (Argo CD Application 생성 — 2.argocd-apps-multi-env.yaml 적용)
- GitLab CI/CD Variables 등록: DOCKERHUB_USERNAME, DOCKERHUB_TOKEN, ARGOCD_PASSWORD

## 순서 (Sequence)
### Step 1: Full CI/CD 파이프라인 파일 복사
- 명령어: `cp ~/_Lecture_cicd_learning.kit/ch8/8.9/1.full-cicd-workflow.yml .gitlab-ci.yml`
- 기대 결과: 프로젝트 루트에 .gitlab-ci.yml 생성/덮어쓰기

### Step 2: 코드 커밋 및 푸시
- 명령어: `git add . && git commit -m "cicd: full CI/CD workflow with Argo CD" && git push origin main`
- 기대 결과: GitLab CI/CD가 main push 이벤트로 자동 트리거

### Step 3: Argo CD 배포 확인
- 명령어: `argocd app list`
- 기대 결과: worklog-backend-dev, worklog-backend-staging, worklog-backend-prod 모두 Healthy/Synced

### Step 4: 각 환경 배포 확인
- 명령어: `kubectl get pods -n dev`, `kubectl get pods -n staging`, `kubectl get pods -n prod`
- 기대 결과: 각 namespace에 worklog-backend Pod Running

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| 파이프라인 트리거 | GitLab CI/CD → Pipelines 확인 | 파이프라인이 자동 실행됨 |
| Argo CD 로그인 | deploy job 로그 | argocd login 성공 |
| Argo CD 동기화 | `argocd app list` | 모든 App이 Healthy/Synced |
| dev 배포 | `kubectl get pods -n dev` | worklog-backend Pod Running |
| staging 배포 | `kubectl get pods -n staging` | worklog-backend Pod Running |
| prod 배포 | `kubectl get pods -n prod` | worklog-backend Pod Running |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| `DOCKERHUB_USERNAME` | GitLab CI/CD Variable로 등록된 Docker Hub 사용자 이름 | ❌ 반드시 확인 필요 |
| `DOCKERHUB_TOKEN` | GitLab CI/CD Variable로 등록된 Docker Hub 토큰 | ❌ 반드시 확인 필요 |
| `ARGOCD_PASSWORD` | GitLab CI/CD Variable로 등록된 Argo CD 관리자 비밀번호 | ❌ 반드시 확인 필요 |

## 주의사항 (Cautions)
- ⛔ GitLab CI/CD Variables에 ARGOCD_PASSWORD가 등록되어 있어야 한다. Masked/Protected 설정을 권장한다.
- ⛔ Argo CD Application이 사전에 생성되어 있어야 한다 (ch8/8.5의 2.argocd-apps-multi-env.yaml).
- ⛔ argoproj/argocd:latest 이미지를 사용하므로 GitLab Runner에서 해당 이미지를 pull 할 수 있어야 한다.
- ✅ argocd app wait --health는 배포가 완료될 때까지 대기하므로, 타임아웃 설정을 고려한다.
- ✅ 배포 실패 시 Argo CD UI에서 상세 에러 로그를 확인할 수 있다.
