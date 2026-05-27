# GUARDRAIL: 8.7 [Jenkins] Full CI/CD workflow (Argo CD)

## 범위 (Scope)
### 이 단계에서 다루는 것
- Jenkins Multibranch Pipeline + Argo CD를 결합한 완전한 CI/CD 워크플로우
- Branch/Tag 기반 환경 판별 후 Argo CD를 통한 배포
- argocd CLI를 사용한 app set, sync, wait 자동화
- Jenkins credentials를 통한 Argo CD 인증 관리

### 이 단계에서 다루지 않는 것
- GitHub Actions / GitLab 기반 워크플로우 (8.4~8.5, 8.8~8.9에서 다룸)
- Argo CD ApplicationSet을 이용한 동적 환경 생성
- Argo Rollouts를 이용한 카나리/블루그린 배포 (ch7에서 다룸)
- Jenkins Shared Library를 이용한 파이프라인 재사용

## 사전 조건 (Prerequisites)
- ch8/8.6 완료 (Jenkins 멀티 환경 파이프라인 기본 이해)
- ch6 완료 (Argo CD 설치 및 설정)
- ch8/8.5 완료 (Argo CD Application 생성 — 2.argocd-apps-multi-env.yaml 적용)
- Jenkins credentials 등록: dockerhub-credentials (Username/Password), argocd-password (Secret text)

## 순서 (Sequence)
### Step 1: Full CI/CD 파이프라인 파일 복사
- 명령어: `cp ~/_Lecture_cicd_learning.kit/ch8/8.7/1.full-cicd-workflow.groovy Jenkinsfile`
- 기대 결과: 프로젝트 루트에 Jenkinsfile 생성/덮어쓰기

### Step 2: 코드 커밋 및 푸시
- 명령어: `git add . && git commit -m "cicd: full CI/CD Jenkins workflow with Argo CD" && git push origin main`
- 기대 결과: main 브랜치에 Jenkinsfile 반영

### Step 3: Jenkins Multibranch Pipeline 스캔
- Dashboard → worklog-backend-multi-env → Scan Multibranch Pipeline Now
- 기대 결과: 각 브랜치별 빌드 트리거, Argo CD를 통한 배포 실행

### Step 4: Argo CD 배포 확인
- 명령어: `argocd app list`
- 기대 결과: worklog-backend-dev, worklog-backend-staging, worklog-backend-prod 모두 Healthy/Synced

### Step 5: 각 환경 배포 확인
- 명령어: `kubectl get pods -n dev`, `kubectl get pods -n staging`, `kubectl get pods -n prod`
- 기대 결과: 각 namespace에 worklog-backend Pod Running

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| 파이프라인 트리거 | Jenkins Dashboard 확인 | 브랜치별 빌드 실행됨 |
| Argo CD 로그인 | Deploy via Argo CD stage 로그 | argocd login 성공 |
| Argo CD 동기화 | `argocd app list` | 모든 App이 Healthy/Synced |
| dev 배포 | `kubectl get pods -n dev` | worklog-backend Pod Running |
| staging 배포 | `kubectl get pods -n staging` | worklog-backend Pod Running |
| prod 배포 | `kubectl get pods -n prod` | worklog-backend Pod Running |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| `argocd-password` | Jenkins에 등록된 Argo CD 비밀번호 credential ID | ❌ 반드시 확인 필요 |
| `dockerhub-credentials` | Jenkins에 등록된 Docker Hub credential ID | ❌ 반드시 확인 필요 |

## 주의사항 (Cautions)
- ⛔ Jenkins에 argocd-password credential이 Secret text 타입으로 등록되어 있어야 한다.
- ⛔ argocd CLI가 Jenkins agent에 설치되어 있어야 한다. 설치되지 않은 경우 Deploy stage에서 실패한다.
- ⛔ Argo CD Application이 사전에 생성되어 있어야 한다 (ch8/8.5의 2.argocd-apps-multi-env.yaml).
- ✅ argocd app wait --health는 배포가 완료될 때까지 대기하므로, 타임아웃 설정을 고려한다.
- ✅ 배포 실패 시 Argo CD UI에서 상세 에러 로그를 확인할 수 있다.
