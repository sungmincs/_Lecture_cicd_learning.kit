# ch6 변경 이력

## [2026-05]

### 6.2/.cmd 신규 추가 [2026-05-27]

- 누락된 `.cmd` 파일 추가 (ch4~ch9 전수 점검 중 발견)
- GUARDRAIL.md의 Step 1~4 순서를 그대로 반영
- install.sh의 HTTPRoute 전환 단계 포함

---

### ch6.2 Argo CD — Ingress → HTTPRoute (Gateway API) 전환

- **Before**: `argocd-manifest.yaml`의 `kind: Ingress`, `ingressClassName: nginx`
- **After**: `argocd-httproute.yaml` — HTTPRoute + ReferenceGrant
- **이유**: ch2 인프라가 NGINX Gateway Fabric으로 전환됨. nginx Ingress Controller 없어서 Ingress가 동작 안 함.

**추가된 파일: `ch6/6.2/argocd-httproute.yaml`**
- `HTTPRoute` (default ns) → `argocd-server` (argocd ns)
- `ReferenceGrant` (argocd ns) — cross-namespace 참조 허용

**`install.sh` 변경:**
- Ingress 삭제 후 HTTPRoute 자동 적용
- 접근 URL: `http://argocd.myk8s.local` (hosts: `192.168.1.99 argocd.myk8s.local`)

### ch6.3 hosts 파일 설정

- **Before**: `192.168.1.99 argocd.myk8s.local` (기존 Ingress Controller IP)
- **After**: 동일 (`192.168.1.99`) — NGF가 `.99`로 고정되어 그대로 유지

---

### ch6.4~6.8 CD 파이프라인 설계 변경 [2026-05-21]

> ⚠️ **강의자 필수 확인 사항**
>
> 기존 강의에서 ch6 CD 파이프라인은 구현/검증된 적 없었음. 전면 재설계.

**GitOps target 저장소 구성 변경:**

- **Before**: `worklog-backend_v1.git` (별도 저장소 — 실제 존재하지 않았음)
- **After**: `worklog-backend.git`의 `deploy_manifest/` 폴더 (학습자 fork 저장소에 신규 추가)
- **이유**: 새 저장소 생성은 학습자 부담. fork한 저장소에 `deploy_manifest/`를 추가하는 것이 자연스러운 흐름

**신규 파일:**

| 파일 | 내용 |
|---|---|
| `ch6/6.4/deploy_manifest/worklog-backend.yaml` | K8s Deployment/Service/HTTPRoute 정답 파일. `<image_tag>`와 `# IMAGE_TAG` 주석으로 sed 업데이트 대상 표시 |

**6.4 Application yaml 변경:**

- `repoURL`: `worklog-backend_v1.git` → `worklog-backend.git`

**6.6 GitHub Actions 파이프라인 변경:**

- `setup-python` → `astral-sh/setup-uv@v5`, `poetry` → `uv`
- `paths-ignore: ['deploy_manifest/**']` 추가 — deploy_manifest 업데이트 시 CI 재트리거 방지
- `argocd login + sync + wait` 제거 — automated sync로 대체 (GitHub Actions shared runner는 로컬 Argo CD 접근 불가)
- `git push`: `token: ${{ secrets.GITHUB_TOKEN }}`으로 체크아웃하여 push 권한 확보

**6.7 Jenkins 파이프라인 변경:**

- `agent { docker { image 'python:...' } }` → `agent any` + curl uv 설치 (K8s Pod 내 docker agent 실행 불가)
- `credentials('dockerhub-token')` → `credentials('dockerhub-credentials')` (ch5.5와 통일)
- `argocd sync` 유지 — Jenkins는 클러스터 내부라 `argocd.myk8s.local` 접근 가능

**ch6 전체 검증 완료 [2026-05-21] ✅ (6.2, 6.4, 6.6, 6.7, 6.8):**

> ⚠️ **강의자 필수 확인 사항 (3가지)**

**1. GitHub Actions workflow 쓰기 권한:**
- GitHub 2022년 이후 GITHUB_TOKEN 기본 권한이 Read-only로 변경됨
- deploy_manifest git push를 위해 저장소 Settings → Actions → General → Workflow permissions → **Read and write permissions** 활성화 필요
- 또는 API: `gh api repos/<owner>/<repo>/actions/permissions/workflow --method PUT --field default_workflow_permissions=write`

**2. Docker Hub imagePullSecret:**
- 인증 없이 pull 시 Docker Hub rate limit(429) 발생
- K8s에 Secret 등록 필요:
  ```bash
  kubectl create secret docker-registry dockerhub-creds \
    --docker-username=<dockerhub_username> \
    --docker-password=<dockerhub_token> \
    --docker-server=https://index.docker.io/v1/
  ```
- deploy_manifest/worklog-backend.yaml에 `imagePullSecrets` 포함됨 (정답 파일 반영 완료)

**3. fastapi[standard] 패키지:**
- `fastapi>=0.111.0` → `fastapi[standard]>=0.111.0` 변경 필요
- fastapi 0.99+ 에서 CLI 실행 시 standard 패키지(uvicorn 등) 필요
- worklog-backend `pyproject.toml` 및 `uv.lock` 업데이트 필요 (sungmin 전달)

**4. multi-platform 빌드 (linux/amd64,linux/arm64):**
- Apple Silicon Mac 학습자는 arm64 클러스터 → amd64 이미지 실행 불가
- ch5.2~5.7, ch6.6~6.8 모든 파이프라인에 `docker buildx`/`setup-buildx-action@v3` + `platforms: linux/amd64,linux/arm64` 추가

**5. MongoDB 사전 배포:**
- worklog-backend 앱이 MongoDB 없으면 시작 불가
- ch6 실습 전 MongoDB 수동 배포 필요 (ch3.4 매니페스트 재사용)
- 또는 6.4 deploy_manifest에 MongoDB 포함 고려

---

**6.7 Jenkins 파이프라인 검증 중 발견 사항:**

- **ARGOCD_SERVER**: `argocd.myk8s.local` → `argocd-server.argocd.svc.cluster.local` (Jenkins Pod 내부 DNS)
- **argocd CLI**: Jenkins Pod에 설치 안 됨 → Sync Argo CD 단계에서 curl로 직접 다운로드
  ```bash
  curl -sSL -o /tmp/argocd https://github.com/argoproj/argo-cd/releases/download/v3.4.2/argocd-linux-arm64
  chmod +x /tmp/argocd
  ```
- **argocd login 비밀번호**: `ARGOCD_ADMIN_PASSWORD` → `ARGOCD_ADMIN_PASSWORD_PSW` (UsernamePassword credential)
- **git push**: `git push origin main` → `git push origin HEAD:main` (Multibranch Pipeline detached HEAD)
- **docker buildx**: Jenkins에 `/usr/lib/docker/cli-plugins/docker-buildx` → `/usr/libexec/docker/cli-plugins/docker-buildx` 추가 마운트 필요
- **multi-platform**: `docker run --privileged --rm tonistiigi/binfmt --install all` 추가 (arm64 노드에서 amd64 에뮬레이션)
- **install_jenkins.sh**: docker-buildx 마운트 추가됨

**6.8 GitLab CI 파이프라인 변경 및 검증 중 발견 사항:**

- `python:3.12.3-slim-bookworm` → `ghcr.io/astral-sh/uv:python3.12-bookworm-slim`, `poetry` → `uv`
- docker 인증: `DOCKER_CONFIG` + config.json 방식 (ch5.6 검증 방식 동일)
- **multi-platform 빌드**: `DOCKER_HOST: tcp://docker:2375` + `DOCKER_TLS_CERTDIR: ""` (TLS 비활성화) + `docker buildx create --name mybuilder --driver docker-container --use`
- **git push**: `CI_JOB_TOKEN` → `GITLAB_TOKEN` variable 사용 (CI_JOB_TOKEN은 push 권한 없음)
  - GitLab CI Variables에 `GITLAB_TOKEN` 추가 필요 (write_repository 권한 PAT)
- **git push**: `git push origin main` → `git push origin HEAD:main` (detached HEAD)
- **CI loop 방지**: `workflow.rules.changes: "!deploy_manifest/**"` → GitLab CI 미지원 → `deploy commit message에 [skip ci]` 추가
  - `workflow.rules`에서 `&&` 복합 조건 사용 불가 → 두 rules로 분리
- **deploy script**: YAML `:`으로 인한 파싱 오류 → `|` block scalar로 전체 script 감싸기
- **GitLab Variables 필수**: `DOCKERHUB_USERNAME`, `DOCKERHUB_TOKEN`, `GITLAB_TOKEN`
- CI loop 방지: commit message에 `[skip ci]` 포함
