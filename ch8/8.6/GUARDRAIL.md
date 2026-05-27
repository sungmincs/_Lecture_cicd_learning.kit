# GUARDRAIL: 8.6 [Jenkins] PR/Branch/Tag 기반 배포 파이프라인 만들기

## 범위 (Scope)
### 이 단계에서 다루는 것
- Jenkins Multibranch Pipeline을 사용한 멀티 환경 배포 파이프라인 구현
- Branch 이름 기반 환경 판별 (develop → dev, release/* → staging)
- Tag 기반 프로덕션 배포 (v*.*.* → prod)
- Jenkins credentials를 활용한 Docker Hub, kubeconfig 관리

### 이 단계에서 다루지 않는 것
- Argo CD 연동 (8.7에서 다룸)
- GitHub Actions / GitLab 기반 파이프라인 (8.4~8.5, 8.8~8.9에서 다룸)
- Jenkins Shared Library를 이용한 파이프라인 재사용
- Webhook 기반 자동 트리거 설정 (ch4에서 다룸)

## 사전 조건 (Prerequisites)
- ch5/5.4 또는 5.5 완료 (Jenkins 빌드/배포 파이프라인 기본 이해)
- ch8/8.2 완료 (dev, staging, prod namespace 생성)
- ch8/8.3 완료 (develop, release/1.0 브랜치 생성)
- Jenkins credentials 등록: dockerhub-credentials (Username/Password), kube-config (Secret file)

## 순서 (Sequence)
### Step 1: Jenkins 멀티 환경 파이프라인 파일 복사 [학습자 직접]
- 명령어: `cp ~/_Lecture_cicd_learning.kit/ch8/8.6/1.multi-env-pipeline.groovy Jenkinsfile`
- 기대 결과: 프로젝트 루트에 Jenkinsfile 생성/덮어쓰기

### Step 2: Groovy 파일에서 플레이스홀더 수정 [AI 프롬프트]
- `<dockerhub_username>`을 본인 Docker Hub 사용자 이름으로 변경
- 기대 결과: DOCKER_REPOSITORY 값이 올바르게 설정됨

### Step 3: 코드 커밋 및 푸시 [학습자 직접]
- 명령어: `git add . && git commit -m "cicd: add multi-environment Jenkins pipeline" && git push origin main`
- 기대 결과: main 브랜치에 Jenkinsfile 반영

### Step 4: Jenkins Multibranch Pipeline 생성 [학습자 직접]
- Jenkins Dashboard → New Item → Multibranch Pipeline
- Branch Sources에 Git 저장소 추가, 브랜치/태그 탐색 활성화
- 기대 결과: develop, release/1.0, main 브랜치 각각에 파이프라인 생성

### Step 5: Scan Multibranch Pipeline [학습자 직접]
- Dashboard → worklog-backend-multi-env → Scan Multibranch Pipeline Now
- 기대 결과: 각 브랜치별 빌드 트리거

### Step 6: 각 환경 배포 확인 [학습자 직접]
- 명령어: `kubectl get pods -n dev`, `kubectl get pods -n staging`, `kubectl get pods -n prod`
- 기대 결과: 각 namespace에 worklog-backend Pod Running

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| Multibranch 설정 | Jenkins Dashboard 확인 | 브랜치별 파이프라인 목록 표시 |
| 환경 판별 | Init Variables stage 로그 | 올바른 environment/namespace 출력 |
| 이미지 빌드 | Docker Hub 저장소 확인 | 환경별 태그로 이미지 존재 |
| dev 배포 | `kubectl get pods -n dev` | worklog-backend Pod Running |
| staging 배포 | `kubectl get pods -n staging` | worklog-backend Pod Running |
| prod 배포 | `kubectl get pods -n prod` | worklog-backend Pod Running |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| `<dockerhub_username>` | Docker Hub 사용자 이름 | ❌ 반드시 확인 필요 |
| `<github_username>` | GitHub 사용자 이름 (Jenkins 설정 시) | ❌ 반드시 확인 필요 |

## 주의사항 (Cautions)
- ⛔ Jenkins Multibranch Pipeline에서 Tag Discovery를 활성화해야 태그 기반 배포가 동작한다.
- ⛔ credentials ID (dockerhub-credentials, kube-config)가 Jenkins에 등록된 이름과 정확히 일치해야 한다.
- ⛔ Docker agent를 사용하는 stage (Run Test)에서는 호스트의 Docker socket이 마운트되어야 한다.
- ✅ Multibranch Pipeline은 브랜치 삭제 시 자동으로 해당 파이프라인을 제거한다.
- ✅ Scan Multibranch Pipeline을 실행하면 모든 브랜치가 한 번에 빌드될 수 있으므로 주의한다.
