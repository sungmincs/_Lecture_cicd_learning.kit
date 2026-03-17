# GUARDRAIL: 5.5 [Jenkins] Plugin 활용 간소화

## 범위 (Scope)
### 이 단계에서 다루는 것
- Docker Pipeline 플러그인을 활용하여 Jenkins 파이프라인 간소화
- `docker.build()` 메서드를 사용한 이미지 빌드
- `docker.withRegistry()` 메서드를 사용한 Docker Hub 인증 및 push
- Jenkins Credentials와 Docker Pipeline 플러그인의 연동
- 5.4 대비 코드 간소화 효과 비교

### 이 단계에서 다루지 않는 것
- 파이프라인의 기본 구조 설계 (5.4에서 완료)
- Docker Pipeline 외 기타 플러그인 (Blue Ocean, Pipeline Utility Steps 등)
- GitHub Actions 또는 GitLab 기반 간소화 (5.3, 5.7에서 다룸)

## 사전 조건 (Prerequisites)
- ch5/5.4 완료 (기본 빌드 파이프라인 구현 및 동작 확인)
- Jenkins Credentials에 `dockerhub-credentials`가 이미 등록된 상태
- Docker Pipeline 플러그인 설치 필요

## 순서 (Sequence)
### Step 1: Docker Pipeline 플러그인 설치
- Dashboard → Jenkins 관리 → Plugins → Available plugins → "Docker Pipeline" 검색 및 설치
- 기대 결과: Docker Pipeline 플러그인이 Installed 목록에 표시됨

### Step 2: 간소화된 Jenkinsfile 복사
- 명령어: `cp ~/_Lecture_cicd_learning.kit/ch5/5.5/1.build-and-push-docker-image-plugin.groovy Jenkinsfile`
- 기대 결과: 기존 Jenkinsfile이 플러그인 기반 버전으로 대체됨

### Step 3: 5.4 버전과 비교
- `Build and Push Image` 스테이지에서 shell 명령 대신 `docker.build()`, `docker.withRegistry()` 사용 확인
- Credentials ID를 `docker.withRegistry()`에 전달하여 인증 처리
- 기대 결과: docker login/build/push shell 명령이 Groovy DSL로 대체된 것을 이해

### Step 4: 코드 커밋 및 푸시
- 명령어: `git add . && git commit -m "cicd: simplify pipeline with Jenkins plugins" && git push origin main`
- 기대 결과: Jenkins Multibranch Pipeline이 변경을 감지

### Step 5: 파이프라인 트리거 및 확인
- Dashboard → worklog-backend-pipeline → Scan Multibranch Pipeline Now
- 기대 결과: 5.4와 동일한 결과이지만 Build and Push Image 스테이지의 코드가 간결해짐

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| 플러그인 설치 | Jenkins → Plugins → Installed | Docker Pipeline 플러그인 설치 확인 |
| 파이프라인 실행 | Jenkins 빌드 로그 확인 | 전체 파이프라인 성공 |
| Docker 빌드 | Build and Push Image 로그 | docker.build() 성공 로그 |
| Docker push | Build and Push Image 로그 | docker.withRegistry() 통한 push 성공 |
| 이미지 확인 | Docker Hub 저장소 확인 | full_sha, short_sha 태그로 이미지 존재 |
| 코드 비교 | 5.4 Groovy와 diff | shell 명령이 Groovy DSL로 대체됨 |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| `<dockerhub_username>` | Docker Hub 사용자 이름 (Credentials에 등록 필요) | ❌ 반드시 확인 필요 |

## 주의사항 (Cautions)
- ⛔ Docker Pipeline 플러그인이 설치되지 않은 상태에서는 `docker.build()`, `docker.withRegistry()` 메서드를 사용할 수 없다.
- ⛔ `docker.withRegistry()`의 첫 번째 인자는 레지스트리 URL이며, Docker Hub의 경우 `https://index.docker.io/v1/`을 사용한다.
- ⛔ Credentials ID(`dockerhub-credentials`)가 5.4에서 등록한 것과 정확히 일치해야 한다.
- ✅ Docker Pipeline 플러그인은 내부적으로 docker login/push를 수행하므로 별도의 shell 명령이 불필요하다.
- ✅ 플러그인 방식은 인증 정보가 로그에 노출되지 않도록 자동으로 마스킹해준다.
