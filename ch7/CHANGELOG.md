# ch7 변경 이력

## [2026-05]

### ch7 검증 완료 [2026-05-21] ✅

| 섹션 | 결과 | 비고 |
|---|---|---|
| 7.3 Rolling Update | ✅ | replicas 3, maxSurge 1, maxUnavailable 0 정상 동작 |
| 7.4 Argo Rollouts 설치 | ✅ | v1.9.0, arm64 바이너리 정상 동작 |
| 7.5 Blue-Green | ✅ | preview/active 분리, manual promote 동작 확인 |
| 7.6 Canary | ✅ | Step 0/8 (20% canary), stable/canary ReplicaSet 분리 확인 |

### 매니페스트 파일 수정

**7.4 install_argo_rollouts.sh:**
- **Before**: `latest` 버전, `linux-amd64` 고정
- **After**: `v1.9.0` 버전 고정, 아키텍처 자동 감지 (arm64/amd64)

**7.3, 7.5, 7.6 매니페스트:**
- `containerPort: 8000` → `containerPort: 80` (fastapi 실제 포트)
- `image: buildtest1` → `<dockerhub_username>/worklog-backend:<image_tag>` (플레이스홀더)
- `imagePullSecrets: dockerhub-creds` 추가 (Docker Hub rate limit 방지)
- MongoDB 환경 변수 추가 (MONGO_HOST, MONGO_INITDB_ROOT_USERNAME, MONGO_INITDB_ROOT_PASSWORD)
- liveness/readiness probe 추가 (`/health`, 80 포트)

> ⚠️ **강의자 필수 확인 사항**
>
> ch7 실습 시 Argo CD와 충돌 방지: `argocd app set worklog-backend --sync-policy none`으로 auto-sync 비활성화 후 실습. 실습 완료 후 `--sync-policy automated --auto-prune --self-heal`로 복원.
