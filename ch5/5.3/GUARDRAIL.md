# GUARDRAIL: 5.3 [GitHub] Marketplace Action 활용 간소화

## 범위 (Scope)
### 이 단계에서 다루는 것
- GitHub Marketplace의 공식 Action을 활용하여 파이프라인 코드 간소화
- `docker/login-action@v3`으로 Docker Hub 로그인 대체
- `docker/build-push-action@v5`으로 Docker 이미지 빌드 및 push 대체
- `azure/k8s-set-context@v4`으로 kubeconfig 설정 대체
- 5.2 대비 코드 간소화 효과 비교

### 이 단계에서 다루지 않는 것
- 파이프라인의 기본 구조 설계 (5.2에서 완료)
- 커스텀 Action 작성
- Self-hosted Runner 구성
- Jenkins 또는 GitLab 기반 간소화 (5.5, 5.7에서 다룸)

## 사전 조건 (Prerequisites)
- ch5/5.2 완료 (기본 빌드 파이프라인 구현 및 동작 확인)
- GitHub Secrets에 DOCKERHUB_TOKEN, CP_K8S_CONTEXT가 이미 등록된 상태

## 순서 (Sequence)
### Step 1: Marketplace Action 파이프라인 YAML 복사 [학습자 직접]
- 명령어: `cp ~/_Lecture_cicd_learning.kit/ch5/5.3/1.build-pipeline-marketplace.yaml ~/workspace/worklog-backend/.github/workflows/1.build-pipeline.yaml`
- 기대 결과: 기존 파이프라인 파일이 Marketplace Action 버전으로 대체됨

### Step 2: 5.2 버전과 비교 [AI 프롬프트]
- `build` job의 docker login/build/push 명령이 Action으로 대체된 것 확인
- 기대 결과: shell 명령 대신 선언적 with 블록으로 간소화된 것을 이해

### Step 3: 플레이스홀더 수정 [AI 프롬프트]
- `1.build-pipeline.yaml`의 `<dockerhub_username>` 플레이스홀더를 실제 값으로 교체
- 기대 결과: 플레이스홀더 없이 실제 값이 채워진 상태

### Step 4: 코드 커밋 및 푸시 [학습자 직접]
- 명령어: `cd ~/workspace/worklog-backend && git add . && git commit -m "cicd: simplify pipeline with marketplace actions" && git push origin main`
- 기대 결과: GitHub Actions가 자동으로 트리거됨

### Step 5: 파이프라인 실행 결과 확인 [학습자 직접]
- GitHub → Actions 탭에서 파이프라인 실행 상태 확인
- 기대 결과: 5.2와 동일한 결과 (init-and-test → build → notify) 이지만 코드가 간결해짐

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| 파이프라인 실행 | GitHub Actions 탭 확인 | 전체 파이프라인 성공 |
| Docker 로그인 | build job 로그 확인 | docker/login-action이 성공적으로 로그인 |
| 이미지 빌드/push | Docker Hub 저장소 확인 | full_sha, short_sha 태그로 이미지 존재 |
| K8s 배포 | `kubectl get pods` | worklog-backend Pod Running |
| 코드 비교 | 5.2 YAML과 diff | build/deploy job의 shell 명령이 Action으로 대체됨 |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| `<github_username>` | GitHub 사용자 이름 | ❌ 반드시 확인 필요 |
| `<dockerhub_username>` | Docker Hub 사용자 이름 | ❌ 반드시 확인 필요 |

## 주의사항 (Cautions)
- ⛔ Marketplace Action 버전(@v3, @v5 등)을 임의로 변경하지 않는다. 호환성 문제가 발생할 수 있다.
- ⛔ `docker/build-push-action`의 `context: .`을 생략하면 빌드 컨텍스트가 올바르게 설정되지 않을 수 있다.
- ✅ 5.2의 Secrets 설정이 그대로 유지되므로 추가 Secrets 등록은 불필요하다.
- ✅ Marketplace Action을 사용하면 shell 명령 실수를 줄이고 유지보수가 용이해진다.
