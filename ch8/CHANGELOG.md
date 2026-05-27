# ch8 변경 이력

## [2026-05]

### GUARDRAIL.md 섹션 번호 정정 [2026-05-27]

**8.2~8.9/GUARDRAIL.md — 헤더 및 본문 참조 수정**
- 헤더: `9.2~9.9` → `8.2~8.9` (ch8 재편 시 미갱신)
- 본문 사전조건: `ch9/9.x 완료` → `ch8/8.x 완료` (전 파일)
- 본문 섹션 범위 참조: `9.4~9.9` → `8.4~8.9` 등 (전 파일)
- 본문 cp/apply 경로: `ch9/9.x/파일명` → `ch8/8.x/파일명` (전 파일)

---

### ch8 파이프라인 전면 재설계 [2026-05-22]

> ⚠️ **강의자 필수 확인 사항**
>
> ch8은 ch6 Argo CD(GitOps) 방식으로 CD 구현. `KUBE_CONFIG` + kubectl 직접 배포 방식 제거.

**변경 방향:**
- **Before**: `kubectl set image` + `KUBE_CONFIG`
- **After**: `deploy_manifest/` 이미지 태그 업데이트 + git push → Argo CD automated sync

**공통 변경:**
- poetry → uv (backend 파이프라인)
- multi-platform 빌드 (`linux/amd64,linux/arm64`)
- `paths-ignore: deploy_manifest/**` 추가 (CI loop 방지)
- `DOCKER_REPOSITORY`: `worklog-frontend` → `worklog-frontend-mock` (실제 이미지 이름 반영)

**필요한 Secret/Variable:**

| 도구 | Secret/Variable |
|---|---|
| GitHub Actions | `DOCKERHUB_TOKEN`, `DOCKERHUB_USERNAME` (write 권한 활성화 필요) |
| Jenkins | `dockerhub-credentials`, `github-token` |
| GitLab CI | `DOCKERHUB_USERNAME`, `DOCKERHUB_TOKEN`, `GITLAB_TOKEN` |

**8.2 매니페스트 수정:**

| 파일 | 변경 내용 |
|---|---|
| `2.worklog-backend-with-db.yaml` | Ingress→HTTPRoute, containerPort 8000→80, env(MONGO_HOST/SECRET), imagePullSecrets |
| `3.worklog-frontend-manifest.yaml` | Ingress→HTTPRoute, containerPort 8080→5173, VITE_API_URL env, imagePullSecrets |

**ch8.3 검증 완료 [2026-05-22] ✅:**

| 파이프라인 | 결과 |
|---|---|
| GitHub Actions Frontend (worklog-frontend-mock) | ✅ |
| GitHub Actions Backend (worklog-backend) | ✅ |

**ch8.4 Jenkins 검증 완료 [2026-05-22] ✅:**

| 파이프라인 | 결과 |
|---|---|
| Jenkins Frontend (worklog-frontend-mock) | ✅ |
| Jenkins Backend (worklog-backend) | ✅ |

> ⚠️ **강의자 필수 확인 사항**: Jenkins는 메모리 제약(3.7GB VM)으로 frontend/backend를 **순차 실행**해야 함. 동시 실행 시 BuildKit 컨테이너 2개가 메모리를 소모하여 K8s API 서버 과부하 발생. VM 재시작 후 `chmod 666 /var/run/docker.sock` 필요.

**검증 중 발견 사항:**
- `git pull --rebase` 추가 필요 (ch6 Argo CD 파이프라인과 동시 실행 시 push 충돌 발생)
- `DOCKERHUB_USERNAME` Secret 별도 등록 필요 (`worklog-backend` 저장소)
- GitHub Actions workflow 쓰기 권한 활성화 필요 (`worklog-frontend-mock` 포함)
- Jenkins 빌드 builder 이름 충돌 방지: frontend는 `frontend-builder`, backend는 `backend-builder`

**ch8.5 GitLab CI 검증 완료 [2026-05-22] ✅:**

| 파이프라인 | 결과 |
|---|---|
| GitLab CI Frontend (worklog-frontend-mock) | ✅ |
| GitLab CI Backend (worklog-backend) | ✅ |

> ⚠️ **강의자 필수 확인 사항**: GitLab에 `SysNet4Admin/worklog-frontend-mock` 프로젝트 신규 생성 필요 (GitHub fork와 별개). GitLab Variables: `DOCKERHUB_USERNAME`, `DOCKERHUB_TOKEN`, `GITLAB_TOKEN`.
