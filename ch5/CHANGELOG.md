# ch5 변경 이력

## [2026-05]

### GUARDRAIL.md 파일명 수정 + 레이블 추가 [2026-05-27]

**5.2, 5.3, 5.6, 5.7 — 파일명 불일치 수정**
- Before: `1.build-deploy-pipeline.*` (CD 제거 전 구버전 명)
- After: `1.build-pipeline.*` (현행 파일명 — CD는 ch6 Argo CD로 분리됨)
- 5.2, 5.6: `deploy_manifest/worklog-backend.yaml` 관련 내용 제거 (파일 삭제됨)

**5.2~5.7 전체 — [학습자 직접] / [AI 프롬프트] 레이블 추가**
- cp 명령, git push, 파이프라인 결과 확인 → [학습자 직접]
- 플레이스홀더 수정, Secrets/Variables 등록 안내, 파일 비교 → [AI 프롬프트]

---

### 플레이스홀더 적용 + poetry → uv 전환

- **Before**: `sungminl/worklog-backend` (하드코딩), `pip install poetry` + `poetry run`
- **After**: `<dockerhub_username>/worklog-backend` (플레이스홀더), `uv sync` + `uv run`
- **이유**: 학습자가 본인 Docker Hub username을 사용해야 함. uv 전환 sungmin confirmed.
- **GitHub Actions**: `actions/setup-python@v5` → `astral-sh/setup-uv@v5`
- **Jenkins**: `python:3.12.3-slim-bookworm` → `ghcr.io/astral-sh/uv:python3.12-bookworm-slim`
- **GitLab CI**: `python:3.12.3-slim-bookworm` → `ghcr.io/astral-sh/uv:python3.12-bookworm-slim`
- **반영 위치**: 6개 파이프라인 파일 전체

---

### ch5 설계 변경: CI + CD → CI only (build → Docker Hub push)

> ⚠️ **강의자 필수 확인 사항**
>
> ch5 대주제가 변경됨. 강의 스크립트에서 "K8s 배포"를 ch5가 아닌 ch6(Argo CD)에서 다룬다는 점 명시 필요.

- **Before**: test → build → **deploy(K8s)** → notify
- **After**: test → build → notify (K8s 배포 없음)
- **이유**: ngrok + ServiceAccount + kubeconfig base64 + Secret 등록 등 K8s 접근 설정이 CI/CD 학습 목적과 무관한 인프라 복잡도를 유발. K8s 배포(CD)는 ch6 Argo CD(GitOps)에서 다루는 것이 더 현업 패턴에 맞고 학습 목적에도 부합.
- **ch5 → ch6 연결 설명**: "CI로 이미지를 Push하면, ch6에서 Argo CD가 이를 감지해 자동 배포"

---

### ch5 검증 결과 [2026-05-20] ✅ 전체 완료

**검증 완료:**

| 섹션 | 결과 | 비고 |
|---|---|---|
| 5.2 GitHub Actions | ✅ | test → docker build → Docker Hub push 전체 정상 |
| 5.3 GitHub Actions Marketplace | ✅ | docker/login-action, docker/build-push-action 정상 |
| 5.4 Jenkins | ✅ | test(uv+pytest) ✅, Build Image(echo) ✅ |
| 5.5 Jenkins Plugin | ✅ | docker.build() + docker.withRegistry() 실제 push ✅ |
| 5.6 GitLab CI | ✅ | test(uv+pytest) ✅, docker build ✅, Docker Hub push ✅ |
| 5.7 GitLab CI Extension | ✅ | extends 템플릿 방식 정상 동작 |

**GitLab CI docker push 인증 방법 변경:**

> ⚠️ **강의자 필수 확인 사항**
>
> GitLab CI에서 Docker Hub push 인증은 `DOCKER_CONFIG` 환경변수 + config.json 직접 생성 방식 사용. `docker login --password-stdin`은 DinD 환경에서 동작하지 않음.

- **인증 방식**: `DOCKER_CONFIG=/tmp/docker_config` 변수 설정 + 스크립트에서 config.json 직접 생성
- **GitLab CI Variables 필수 등록** (학습자가 직접 등록해야 함):
  - `DOCKERHUB_USERNAME`: Docker Hub username
  - `DOCKERHUB_TOKEN`: Docker Hub Access Token (read/write 권한)
- **반영 위치**: `5.6/1.build-pipeline.yml`, `5.7/1.build-pipeline-extension.yml`

---

**Jenkins docker 환경 구성 [2026-05-20] ✅:**

> ⚠️ **강의자 필수 확인 사항**
>
> ch2.11 Docker 설치 선행 필수. install_jenkins.sh가 자동으로 docker socket 마운트.

- **ch2.11**: `docker_all_nodes_installer.sh`로 전체 노드에 Docker 29.3.1 설치 (containerd CRI와 병행)
- **install_jenkins.sh 변경**:
  - `docker-workflow:634.vedc7242b_eda_7` 플러그인 추가 (ch5.5 Docker Plugin 방식용)
  - `kubectl patch statefulset jenkins`로 `/var/run/docker.sock`, `/usr/bin/docker` hostPath 마운트
  - `chmod 666 /var/run/docker.sock` 자동 설정 (Jenkins UID 1000이 docker group GID 988 미포함)
- **주의**: Helm chart `controller.volumes/volumeMounts`로는 hostPath가 Pod spec에 미적용됨 → `kubectl patch` 방식 사용
- **반영 위치**: `ch4/4.5/install_jenkins.sh`

**5.5 Run Test stage 변경:**

- **Before**: `agent { docker { image 'ghcr.io/astral-sh/uv:...' } }` — K8s Pod 내 docker agent 실행 불가
- **After**: `agent any` + `curl -LsSf https://astral.sh/uv/install.sh | sh` — built-in executor에서 uv 설치
- **이유**: Jenkins Pod 내부에서 docker container를 agent로 실행하면 `process apparently never started` 오류
- **Build and Push Image stage**: `docker.build()` + `docker.withRegistry()` Docker Pipeline Plugin 방식 유지 ✅

**multi-platform 빌드 추가 [2026-05-21]:**

> ⚠️ **강의자 필수 확인 사항**
>
> Apple Silicon Mac 학습자 환경(arm64 클러스터)에서 GitHub Actions(amd64) 빌드 이미지가 실행 안 됨 → 전체 파이프라인에 multi-platform 빌드 추가.

- **Before**: `docker build` (단일 플랫폼 amd64)
- **After**: `docker buildx build --platform linux/amd64,linux/arm64`
- **GitHub Actions (5.2)**: `docker/setup-buildx-action@v3` 추가 + `docker buildx build --push`
- **GitHub Actions (5.3)**: `docker/build-push-action@v5`에 `platforms: linux/amd64,linux/arm64` 추가
- **Jenkins (5.5)**: `docker.withRegistry()` 내부에서 `docker buildx build --push`
- **GitLab CI (5.6, 5.7)**: `docker buildx create --use` + `docker buildx build --platform ... --push`
- **5.2, 5.3에 `paths-ignore: ['deploy_manifest/**']` 추가** — ch6 deploy_manifest 업데이트 시 CI loop 방지

---

**worklog-backend 저장소 변경 사항 (검증 과정에서 발생):**

> ⚠️ **강의자 필수 확인 사항**
>
> `sungmincs/worklog-backend` 원본 저장소에 아래 변경 적용 필요. 학습자가 fork 시 이 파일들이 포함되어야 함.

| 파일 | 변경 내용 | 이유 |
|---|---|---|
| `pyproject.toml` | poetry → uv (PEP 621 형식, hatchling 빌드 백엔드) | uv 전환 |
| `uv.lock` | 신규 추가 (poetry.lock 대체) | uv 전환 |
| `Dockerfile` | poetry export → `uv export --no-dev --no-hashes --no-emit-project` | uv 전환 |
| `src/worklog/conftest.py` | `AsyncClient(app=)` → `ASGITransport` | httpx 0.28+ 호환 |

---

**제거된 파일:**

| 파일 | 제거 이유 |
|---|---|
| `ch5/generate_sa_kube_context.sh` | ngrok 기반 kubeconfig 생성 스크립트 — CI only 전환으로 불필요 |
| `ch5/5.2/deploy_manifest/worklog-backend.yaml` | K8s 배포 매니페스트 — ch6에서 별도 구성 |

**변경된 파일:**

| Before | After | 변경 내용 |
|---|---|---|
| `5.2/1.build-deploy-pipeline.yaml` | `5.2/1.build-pipeline.yaml` | deploy job 제거, 파일명 변경 |
| `5.3/1.build-deploy-pipeline-marketplace.yaml` | `5.3/1.build-pipeline-marketplace.yaml` | deploy job 제거, 파일명 변경 |
| `5.4/1.build-and-push-docker-image.groovy` | (동일) | 'Deploy Image' stage 제거 |
| `5.5/1.build-and-push-docker-image-plugin.groovy` | (동일) | 'Deploy Image' stage 제거 |
| `5.6/1.build-deploy-pipeline.yml` | `5.6/1.build-pipeline.yml` | deploy job 제거, 파일명 변경 |
| `5.7/1.build-deploy-pipeline-extension.yml` | `5.7/1.build-pipeline-extension.yml` | deploy job 제거, 파일명 변경 |
