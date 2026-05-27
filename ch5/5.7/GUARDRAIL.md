# GUARDRAIL: 5.7 [GitLab] Extension 활용 간소화

## 범위 (Scope)
### 이 단계에서 다루는 것
- GitLab CI/CD의 `extends` 키워드를 활용하여 파이프라인 코드 간소화
- 숨김 job(`.docker-job`, `.notify-template`)을 템플릿으로 정의하여 재사용
- `before_script`를 템플릿에 포함하여 공통 로직 추출
- 5.6 대비 코드 간소화 및 중복 제거 효과 비교

### 이 단계에서 다루지 않는 것
- 파이프라인의 기본 구조 설계 (5.6에서 완료)
- `include` 키워드를 사용한 외부 YAML 파일 참조 (고급 주제)
- GitHub Actions 또는 Jenkins 기반 간소화 (5.3, 5.5에서 다룸)

## 사전 조건 (Prerequisites)
- ch5/5.6 완료 (기본 빌드 파이프라인 구현 및 동작 확인)
- GitLab CI/CD Variables에 DOCKERHUB_USERNAME, DOCKERHUB_TOKEN, CP_K8S_CONTEXT가 이미 등록된 상태

## 순서 (Sequence)
### Step 1: 간소화된 파이프라인 YAML 복사 [학습자 직접]
- 명령어: `cp ~/_Lecture_cicd_learning.kit/ch5/5.7/1.build-pipeline-extension.yml .gitlab-ci.yml`
- 기대 결과: 기존 `.gitlab-ci.yml`이 extends 기반 버전으로 대체됨

### Step 2: 5.6 버전과 비교 [AI 프롬프트]
- `.docker-job` 템플릿: Docker-in-Docker 설정 및 docker login을 `before_script`로 공통화
- `.notify-template` 템플릿: notify job들의 공통 설정(stage, image, needs) 추출
- `build` job이 `extends: .docker-job`으로 Docker 설정을 상속받는 것 확인
- 기대 결과: 중복 설정이 제거되고 코드가 간결해진 것을 이해

### Step 3: 코드 커밋 및 푸시 [학습자 직접]
- 명령어: `cd ~/workspace/worklog-backend-gitlab && git add . && git commit -m "cicd: simplify pipeline with GitLab extensions" && git push origin main`
- 기대 결과: GitLab CI/CD 파이프라인이 자동으로 트리거됨

### Step 4: 파이프라인 실행 결과 확인 [학습자 직접]
- GitLab → CI/CD → Pipelines에서 파이프라인 실행 상태 확인
- 기대 결과: 5.6과 동일한 결과(init → test → build → notify)이지만 코드가 간결해짐

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| 파이프라인 실행 | GitLab CI/CD → Pipelines | 전체 파이프라인 성공 |
| Docker 로그인 | build job 로그 확인 | before_script에서 docker login 성공 |
| 이미지 빌드/push | Docker Hub 저장소 확인 | full_sha, short_sha 태그로 이미지 존재 |
| K8s 배포 | `kubectl get pods` | worklog-backend Pod Running |
| 코드 비교 | 5.6 YAML과 diff | extends로 중복 설정이 제거됨 |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| `<dockerhub_username>` | Docker Hub 사용자 이름 | ❌ 반드시 확인 필요 |

## 주의사항 (Cautions)
- ⛔ 숨김 job(이름이 `.`으로 시작하는 job)은 실행되지 않으며, 오직 템플릿으로만 사용된다.
- ⛔ `extends`로 상속받은 설정은 자식 job에서 동일 키로 재정의할 수 있으며, 이때 부모 설정이 덮어씌워진다.
- ⛔ `before_script`를 템플릿에서 정의하고 자식 job에서도 정의하면, 자식의 `before_script`만 실행된다 (병합되지 않음).
- ✅ 5.6의 CI/CD Variables 설정이 그대로 유지되므로 추가 변수 등록은 불필요하다.
- ✅ `extends`를 사용하면 파이프라인 유지보수가 용이해지고, Docker 설정 변경 시 템플릿 한 곳만 수정하면 된다.
