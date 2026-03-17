# GUARDRAIL: 4.5 Jenkins 설치 및 첫 파이프라인 (Hello World)

> **Jenkins 초기 구성 단계** — 이 도구가 처음으로 설정됩니다. 구성 완료 검증: http://jenkins.myk8s.local 접속 가능 여부

## 범위 (Scope)
### 이 단계에서 다루는 것
- Jenkins를 K8s 클러스터에 Helm으로 설치
- Jenkins 웹 UI 접속 및 초기 설정
- Git credential 설정 (SSH Key)
- 플러그인 설치 (Github, Github Branch Source, Pipeline: Stage View)
- Multibranch Pipeline 생성
- Jenkinsfile로 Hello World 파이프라인 실행

### 이 단계에서 다루지 않는 것
- 빌드 파이프라인 구조 (4.6에서 다룸)
- 실제 Docker 빌드 (ch5에서 다룸)
- GitHub Actions, GitLab CI/CD

## 사전 조건 (Prerequisites)
- ch2 완료 (K8s 클러스터 가동 중)
- Helm 사용 가능
- hosts 파일에 jenkins.myk8s.local 추가 가능

## 순서 (Sequence)

### Step 1: Helm Repo 추가
- 명령어:
  ```bash
  helm repo add edu https://k8s-edu.github.io/Lkv1_main/helm-charts/v1.35/cicd/
  ```
- 기대 결과: helm repo가 추가됨

### Step 2: Jenkins 설치
- 명령어:
  ```bash
  ./install_jenkins.sh
  ```
- 기대 결과: Jenkins가 K8s 클러스터에 배포됨

### Step 3: Hosts 파일에 jenkins.myk8s.local 추가
- 호스트 PC의 hosts 파일에 추가:
  ```
  192.168.1.99 jenkins.myk8s.local
  ```
- 기대 결과: 브라우저에서 jenkins.myk8s.local로 접속 가능

### Step 4: Jenkins 로그인
- URL: http://jenkins.myk8s.local
- 계정: `admin` / `admin`
- 기대 결과: Jenkins 대시보드 표시

### Step 5: Git Credential 설정
- 경로: Dashboard → Jenkins 관리 → Credentials → System → Global Credentials
- 설정값:
  - Kind: SSH Username with private key
  - Scope: Global
  - ID: `cicd-k8s-git-private-key`
  - Private Key: Enter directly (SSH 개인키 붙여넣기)
  - Passphrase: 없음
- 추가 설정: Dashboard → Jenkins 관리 → Security
  - Git Host Key Verification Configuration → Host Key Verification Strategy → **Accept first connection**
- 기대 결과: Git credential이 등록됨

### Step 6: 플러그인 설치
- 필요 플러그인: Github, Github Branch Source, Pipeline: Stage View
- 경로: Dashboard → Jenkins 관리 → Plugins
- 기대 결과: 3개 플러그인이 설치됨

### Step 7: Multibranch Pipeline 생성
- 경로: Dashboard → 새로운 Item
- Item name: `worklog-backend-pipeline`
- Type: Multibranch Pipeline
- Branch Sources: GitHub
  - Repository URL: `https://github.com/<github_username>/worklog-backend.git`
  - Credentials: GitHub username/PAT
- 기대 결과: Pipeline이 생성되고 브랜치를 스캔함

### Step 8: Jenkinsfile로 Hello World 실행
- 참고 파일: `Jenkinsfiles/1.hello-jenkins.groovy`, `Jenkinsfiles/2.hello-jenkins_variables.groovy`
- worklog-backend 리포지토리에 Jenkinsfile을 추가하고 push
- 기대 결과: Jenkins에서 파이프라인이 자동 실행되고 성공

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| Jenkins 접속 | http://jenkins.myk8s.local | 로그인 화면 표시 |
| 로그인 | admin/admin으로 로그인 | 대시보드 표시 |
| Credential | Jenkins 관리 → Credentials | cicd-k8s-git-private-key 존재 |
| 플러그인 | Jenkins 관리 → Plugins → Installed | 3개 플러그인 설치 확인 |
| Pipeline | worklog-backend-pipeline 클릭 | 파이프라인 실행 성공 (파란색/녹색) |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| (없음) | Jenkins는 admin/admin 고정 | |

## 주의사항 (Cautions)
- ⛔ AI가 하지 말아야 할 것: Jenkins UI 조작을 수강생 대신 수행하지 말 것 — UI 경로만 안내하고, 수강생이 직접 클릭하여 설정해야 함
- ⛔ AI가 하지 말아야 할 것: 스크린샷 없이 UI 조작을 상세 설명하지 말 것 — UI 경로(메뉴 → 하위메뉴)로만 안내
- ⛔ AI가 하지 말아야 할 것: install_jenkins.sh 스크립트를 수정하지 말 것
- ✅ AI가 해도 되는 것: Jenkins Pod 상태 확인 (`kubectl get pods`) 및 트러블슈팅
- ✅ AI가 해도 되는 것: Jenkinsfile 문법 설명
- ✅ AI가 해도 되는 것: Helm 설치 오류 트러블슈팅
