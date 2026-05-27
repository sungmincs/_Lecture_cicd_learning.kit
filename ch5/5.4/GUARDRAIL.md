# GUARDRAIL: 5.4 [Jenkins] 빌드 파이프라인 실제로 구현하기

## 범위 (Scope)
### 이 단계에서 다루는 것
- Jenkins Declarative Pipeline으로 Docker 이미지 빌드 및 push 파이프라인 구현
- Jenkins Credentials를 활용한 Docker Hub 인증 정보 관리
- Docker agent를 사용한 테스트 환경 구성 (python:3.12.3-slim-bookworm)
- 커밋 메타데이터(SHA, branch, message)를 활용한 이미지 태깅
- Post-build 알림 (success/failure/aborted) 처리

### 이 단계에서 다루지 않는 것
- Jenkins Plugin을 활용한 간소화 (5.5에서 다룸)
- GitHub Actions 또는 GitLab 기반 파이프라인 (5.2~5.3, 5.6~5.7에서 다룸)
- Jenkins 설치 및 초기 설정 (ch4/4.5에서 완료)
- Multibranch Pipeline 구성 (ch4/4.6에서 완료)

## 사전 조건 (Prerequisites)
- ch4/4.5 완료 (Jenkins 설치 및 기본 구성)
- ch4/4.6 완료 (Jenkins Pipeline 구성 및 Multibranch Pipeline 이해)
- Docker Hub 계정 생성 및 Access Token 발급
- Jenkins에 Docker가 설치되어 있고 Jenkins 사용자가 Docker 명령 실행 가능
- worklog-backend 저장소가 GitHub에 push된 상태

## 순서 (Sequence)
### Step 1: Jenkins Credentials에 Docker Hub 인증 정보 등록 [AI 프롬프트]
- Dashboard → Jenkins 관리 → Credentials → System → Global Credentials → Add Credentials
- Kind: Username with password
- ID: `dockerhub-credentials`
- Username: `<dockerhub_username>`
- Password: `<dockerhub_token>`
- 기대 결과: Global Credentials 목록에 dockerhub-credentials 항목 확인

### Step 2: Jenkinsfile 복사 [학습자 직접]
- 명령어: `cp ~/_Lecture_cicd_learning.kit/ch5/5.4/1.build-and-push-docker-image.groovy Jenkinsfile`
- 기대 결과: 저장소 루트에 Jenkinsfile 파일 생성

### Step 2-1: 플레이스홀더 수정 [AI 프롬프트]
- `Jenkinsfile`의 `<dockerhub_username>` 플레이스홀더를 실제 Docker Hub 사용자 이름으로 교체
- 기대 결과: 플레이스홀더 없이 실제 값이 채워진 상태

### Step 3: 코드 커밋 및 푸시 [학습자 직접]
- 명령어: `git add . && git commit -m "cicd: add build and deploy Jenkins pipeline" && git push origin main`
- 기대 결과: 저장소에 Jenkinsfile이 추가됨

### Step 4: Jenkins에서 파이프라인 트리거 [학습자 직접]
- Dashboard → worklog-backend-pipeline → Scan Multibranch Pipeline Now
- 기대 결과: 파이프라인이 자동으로 감지되어 빌드 시작

### Step 5: 파이프라인 실행 결과 확인 [학습자 직접]
- Dashboard → worklog-backend-pipeline → main → 빌드 번호 클릭 → Console Output
- 기대 결과: Init Variables → Run Test → Build Image → Deploy Image 순서로 실행 완료

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| Credentials 등록 | Jenkins → Credentials 목록 확인 | dockerhub-credentials 존재 |
| 파이프라인 감지 | Multibranch Pipeline Scan 로그 | main 브랜치 Jenkinsfile 감지 |
| 테스트 통과 | Run Test 스테이지 로그 | python:3.12.3-slim-bookworm 컨테이너에서 테스트 성공 |
| 이미지 빌드 | Build Image 스테이지 로그 | Docker 이미지 빌드 및 push 성공 로그 |
| 이미지 확인 | Docker Hub 저장소 확인 | full_sha, short_sha 태그로 이미지 존재 |
| 배포 확인 | Deploy Image 스테이지 로그 | 배포 성공 메시지 출력 |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| `<dockerhub_username>` | Docker Hub 사용자 이름 | ❌ 반드시 확인 필요 |
| `<dockerhub_token>` | Docker Hub Access Token | ❌ 반드시 확인 필요 |

## 주의사항 (Cautions)
- ⛔ Docker Hub 인증 정보를 Jenkinsfile에 직접 하드코딩하지 않는다. 반드시 Jenkins Credentials를 사용한다.
- ⛔ Jenkins 노드에서 Docker 데몬이 실행 중이어야 하며, Jenkins 사용자가 docker 그룹에 포함되어야 한다.
- ✅ Docker agent 사용 시 Jenkins 노드에 Docker가 설치되어 있어야 한다.
- ✅ Multibranch Pipeline이 Jenkinsfile을 자동 감지하려면 저장소 루트에 `Jenkinsfile`이 있어야 한다.
