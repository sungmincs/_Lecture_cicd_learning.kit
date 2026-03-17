# GUARDRAIL: 4.7 GitLab CI/CD 첫 파이프라인 (Hello World)

> **GitLab CI/CD 초기 구성 단계** — 이 도구가 처음으로 설정됩니다.

## 범위 (Scope)
### 이 단계에서 다루는 것
- GitLab.com 무료 가입
- worklog-backend 리포지토리를 GitLab으로 fork
- SSH 키 생성 및 GitLab에 등록
- Git clone (SSH)
- .gitlab-ci.yml로 Hello World 파이프라인 작성 및 실행
- GitLab CI/CD 변수 사용법 학습

### 이 단계에서 다루지 않는 것
- 빌드 파이프라인 구조 (4.8에서 다룸)
- 실제 Docker 빌드 (ch5에서 다룸)
- GitHub Actions, Jenkins

## 사전 조건 (Prerequisites)
- ch3 완료
- K8s 클러스터의 control plane 노드에 접근 가능

## 순서 (Sequence)

### Step 1: GitLab.com 가입
- https://gitlab.com/ 접속
- **주의**: 무료 가입 메뉴가 숨겨져 있음 → **Sign in → Register Now** 클릭
- 기대 결과: GitLab 계정 생성 완료

### Step 2: worklog-backend Fork
- https://gitlab.com/sungmincs/worklog-backend 에서 fork
- Fork 시 프로젝트 이름을 `worklog-backend-gitlab`으로 변경
- 기대 결과: 수강생의 GitLab 계정에 `worklog-backend-gitlab` 프로젝트 생성

### Step 3: SSH 키 생성
- K8s controller 노드에서 실행:
  ```bash
  ssh-keygen -t ed25519 -C "your_email@example.com"
  ```
  - 파일 경로: 기본값 (Enter)
  - Passphrase: 빈 값도 가능
- 기대 결과: `~/.ssh/id_ed25519` (개인키)와 `~/.ssh/id_ed25519.pub` (공개키) 생성

### Step 4: 공개키를 GitLab에 등록
- 공개키 확인: `cat ~/.ssh/id_ed25519.pub`
- GitLab: Edit Profile → SSH Keys → Add New Key → 공개키 붙여넣기
- 기대 결과: SSH Key가 GitLab에 등록됨

### Step 5: Git Clone (SSH)
- 명령어:
  ```bash
  git clone git@gitlab.com:<username>/worklog-backend-gitlab.git
  ```
- 기대 결과: 리포지토리가 clone됨

### Step 6: Hello World 파이프라인 작성 및 실행
- 명령어:
  ```bash
  cd worklog-backend-gitlab
  cp ~/_Lecture_cicd_learning.kit/ch4/4.7/1.hello-gitlab.yml .gitlab-ci.yml
  git add .
  git commit -m "add hello world .gitlab-ci.yml pipeline"
  git push origin main
  ```
- 참고 파일: `1.hello-gitlab.yml`
- GitLab > Build > Pipelines에서 확인
- 기대 결과: 파이프라인이 실행되고 성공

### Step 7: 변수 버전 적용
- 명령어:
  ```bash
  cp ~/_Lecture_cicd_learning.kit/ch4/4.7/2.hello-gitlab-variables.yml .gitlab-ci.yml
  git add .
  git commit -m "update .gitlab-ci.yml to learn variables"
  git push origin main
  ```
- 참고 파일: `2.hello-gitlab-variables.yml`
- 참고 문서: https://docs.gitlab.com/ee/ci/variables/predefined_variables.html
- 기대 결과: 변수를 사용하는 파이프라인이 실행되고 성공

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| GitLab 가입 | gitlab.com 로그인 | 정상 로그인 |
| Fork | 수강생의 GitLab 프로젝트 목록 | worklog-backend-gitlab 존재 |
| SSH 키 | `ls ~/.ssh/id_ed25519*` | 두 파일 존재 |
| Clone | `ls worklog-backend-gitlab/` | 리포지토리 파일 확인 |
| Hello World | GitLab > Build > Pipelines | 파이프라인 성공 (녹색) |
| 변수 버전 | GitLab > Build > Pipelines > 최신 실행 로그 | 변수 값 정상 출력 |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| `<username>` | 수강생의 GitLab 사용자명 | ❌ 반드시 수강생에게 확인 |
| `your_email@example.com` | 수강생의 이메일 주소 (SSH 키 코멘트용) | ❌ 반드시 수강생에게 확인 |

## 주의사항 (Cautions)
- ⛔ AI가 하지 말아야 할 것: `<username>`이나 이메일을 임의로 채우지 말 것
- ⛔ AI가 하지 말아야 할 것: SSH 키의 passphrase를 강제하지 말 것 — 빈 값도 허용됨
- ⛔ AI가 하지 말아야 할 것: ssh-keygen의 파일 경로를 기본값이 아닌 값으로 변경하지 말 것 — SSH config 설정이 복잡해짐
- ✅ AI가 해도 되는 것: GitLab 무료 가입 경로 안내 (Sign in → Register Now)
- ✅ AI가 해도 되는 것: SSH 연결 테스트 방법 안내 (`ssh -T git@gitlab.com`)
- ✅ AI가 해도 되는 것: .gitlab-ci.yml 문법 설명
