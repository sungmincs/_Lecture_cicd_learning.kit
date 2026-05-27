# GUARDRAIL: 5.2 [GitHub] 빌드 파이프라인 실제로 구현하기

## 범위 (Scope)
### 이 단계에서 다루는 것
- GitHub Actions를 사용하여 Docker 이미지 빌드 및 Docker Hub push 파이프라인 구현
- GitHub Secrets를 활용한 민감 정보(Docker Hub 토큰) 관리
- 커밋 메타데이터(SHA, branch, message)를 활용한 이미지 태깅 전략
- 파이프라인 성공/실패 알림 구현

### 이 단계에서 다루지 않는 것
- GitHub Marketplace Action을 활용한 간소화 (5.3에서 다룸)
- Jenkins 또는 GitLab 기반 파이프라인 (5.4~5.5, 5.6~5.7에서 다룸)
- Helm 차트를 이용한 배포
- 멀티 환경(staging/production) 배포 전략

## 사전 조건 (Prerequisites)
- ch4/4.3, 4.4 완료 (GitHub Actions 기본 구성 및 워크플로우 이해)
- Docker Hub 계정 생성 및 Access Token 발급
- worklog-backend 저장소가 GitHub에 push된 상태

## 순서 (Sequence)
### Step 1: GitHub Secrets 등록 [AI 프롬프트]
- GitHub 저장소 → Settings → Secrets and variables → Actions
- `DOCKERHUB_TOKEN`: Docker Hub Access Token 등록
- 기대 결과: Secrets 목록에 1개 항목 확인

### Step 2: 파이프라인 YAML 파일 복사 [학습자 직접]
- 명령어: `cp ~/_Lecture_cicd_learning.kit/ch5/5.2/1.build-pipeline.yaml .github/workflows/1.build-pipeline.yaml`
- 기대 결과: `.github/workflows/` 디렉토리에 파이프라인 파일 생성

### Step 3: 플레이스홀더 수정 [AI 프롬프트]
- `1.build-pipeline.yaml`의 `<dockerhub_username>` 플레이스홀더를 실제 Docker Hub 사용자 이름으로 교체
- 기대 결과: 플레이스홀더 없이 실제 값이 채워진 상태

### Step 4: 코드 커밋 및 푸시 [학습자 직접]
- 명령어: `git add . && git commit -m "cicd: add build pipeline actions" && git push origin main`
- 기대 결과: GitHub Actions가 자동으로 트리거됨

### Step 5: 파이프라인 실행 결과 확인 [학습자 직접]
- GitHub → Actions 탭에서 파이프라인 실행 상태 확인
- 기대 결과: init-and-test → build → notify-success-result 순서로 실행 완료

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| Secrets 등록 | GitHub Settings → Secrets 확인 | DOCKERHUB_TOKEN 존재 |
| 파이프라인 트리거 | GitHub Actions 탭 확인 | 워크플로우가 자동 실행됨 |
| 테스트 통과 | init-and-test job 로그 확인 | poetry test 성공, coverage 출력 |
| 이미지 빌드 | Docker Hub 저장소 확인 | full_sha, short_sha 태그로 이미지 존재 |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| `<github_username>` | GitHub 사용자 이름 | ❌ 반드시 확인 필요 |
| `<dockerhub_username>` | Docker Hub 사용자 이름 | ❌ 반드시 확인 필요 |
| `<dockerhub_token>` | Docker Hub Access Token | ❌ 반드시 확인 필요 |

## 주의사항 (Cautions)
- ⛔ Docker Hub 토큰을 YAML 파일에 직접 하드코딩하지 않는다. 반드시 GitHub Secrets를 사용한다.
- ⛔ `env.DOCKERHUB_USERNAME` 값은 파이프라인 YAML에 하드코딩되어 있으므로 본인 계정으로 수정해야 한다.
- ✅ Secrets 등록 시 값 앞뒤에 공백이 포함되지 않도록 주의한다.
