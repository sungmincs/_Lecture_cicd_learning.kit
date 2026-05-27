# ch9 변경 이력

## [2026-05] 챕터 구조 변경

### GUARDRAIL.md 설계 이슈 보완 [2026-05-27]

**9.7 vs 9.8 환경 혼동 방지**
- 9.7 GUARDRAIL에 환경별 자동화 수준 표 추가 (dev/staging=자동, prod=수동 승인, 9.8 AnalysisTemplate 미적용)
- 9.8 GUARDRAIL 범위에 "적용 환경: dev/staging 전용. prod는 9.7 수동 승인 방식 유지" 명시
- 이유: 9.7에서 prod syncPolicy 제거 후 9.8에서 같은 prod에 Rollout 적용하면 논리 모순 발생

**9.3~9.6 누적 파이프라인 관계 명시**
- 9.3, 9.4: "이 파일은 개념 학습용 독립 파이프라인. 9.5에서 통합 파이프라인으로 교체됨" 안내 추가
- 9.5: "lint + security + coverage 통합 파이프라인. 기존 lint.yaml, security.yaml 삭제 명령 추가"
- 9.6: "최종 누적 파이프라인(lint→security→test→build→trivy→deploy). coverage.yaml 삭제 명령 추가"
- 이유: 각 섹션이 독립 파일로 보여 학습자가 파이프라인을 어떻게 통합하는지 불명확했음

---

### GUARDRAIL.md 섹션 번호 정정 [2026-05-27]

**9.2/GUARDRAIL.md — 헤더 수정**
- 헤더: `A.001 AI 시대에 변화하는 CI/CD` → `9.2 AI 시대에 변화하는 CI/CD` (A 보강에서 ch9로 이동 시 미갱신)

---

### ch9 CI/CD 강화로 재구성 [2026-05-27]

기존 ch9 (멀티환경 배포 패턴)이 ch8로 이동하고, 신규 ch9 "CI/CD 강화: 품질과 보안 게이트 구축하기"로 재구성됨.

**변경 배경:**
- 기존 A (보강) 챕터를 ch9로 정식 통합
- ch7+ch8 머지(배포 전략 + 마이크로서비스) → 빈 자리에 CI/CD 강화 배치
- "AI 시대" 맥락 + 실무 CI/CD 게이트 학습

---

## ch9 검증 완료 [2026-05-27]

| 섹션 | 내용 | 결과 | 비고 |
|---|---|---|---|
| 9.3 | Lint (ruff) | ✅ | |
| 9.4 | Security Scan (pip-audit, gitleaks) | ✅ | starlette PYSEC-2026-161 실취약점 발견 → 1.0.0→1.0.1 수정 |
| 9.5 | Test Coverage 80% | ✅ | |
| 9.6 | Trivy 이미지 스캔 | ⚠️ | 실 CRITICAL/HIGH 취약점 발견 |
| 9.7 | prod 수동 승인 게이트 | ✅ | Argo CD syncPolicy: Manual 적용 |
| 9.8 | 자동 롤백 (AnalysisTemplate) | ✅ | DNS + MongoDB env 수정 후 Healthy |

### 검증 중 발견 사항

**9.4 Security Scan:**
- `starlette 1.0.0` → PYSEC-2026-161 취약점 발견 (pip-audit 정상 동작)
- `worklog-backend/pyproject.toml`에 `starlette>=1.0.1` 업데이트
- `.gitleaks.toml`: `[[rules.allowlist]]` (slice) → `[allowlist]` (map) 수정 (gitleaks v8 구문)

**9.6 Trivy:**
- Docker 이미지(Python 기반)에 실제 CRITICAL/HIGH 취약점 존재
- → Trivy 게이트가 정상 동작하는 것 (false negative 아님)
- 실제 강의에서는 취약점 발견 → 기반 이미지 업그레이드 흐름으로 활용 가능
- ⚠️ **sungmin 확인 필요**: 강의 시연용 이미지 취약점 수준 조절 (base image 업그레이드 또는 severity 레벨 조정)

**9.8 AnalysisTemplate:**
- URL `http://{{args.service-name}}/health` → `http://{{args.service-name}}.default.svc.cluster.local/health` (DNS 수정)
- MongoDB 환경변수 누락 → `MONGO_HOST`, `MONGO_INITDB_ROOT_USERNAME`, `MONGO_INITDB_ROOT_PASSWORD` 추가
- AnalysisTemplate `successCondition: result[0] >= 0.95` — `/health` endpoint가 string("ok") 반환하므로 주의 (숫자 조건 적용 안 됨)
  - ⚠️ **sungmin 확인 필요**: health check 기반 Analysis or Prometheus 메트릭 기반으로 변경 검토

### worklog-backend 저장소 변경 사항

- `pyproject.toml`: `starlette>=1.0.1` 추가, `pip-audit>=2.7.0` dev 의존성 추가
- `ruff.toml`: lint 설정 추가 (`E`, `F`, `W`, `I` 룰)
- `.gitleaks.toml`: secret scan 설정 추가
- `.github/workflows/9.3.lint.yaml`: lint 전용 파이프라인
- `.github/workflows/9.4.security.yaml`: security scan 파이프라인
- `.github/workflows/9.5.coverage.yaml`: coverage 임계값 파이프라인
- `.github/workflows/9.6.trivy.yaml`: Trivy 이미지 스캔 파이프라인
