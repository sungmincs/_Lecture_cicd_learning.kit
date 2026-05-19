# ch4 변경 이력

## [2026-05]

### Jenkins `2.440.3` → `2.541.3`

> ⚠️ **강의자 필수 확인 사항**
>
> `sungminl/inbound-agent-docker` 이미지를 새 버전으로 재빌드 필요.

- **Before**: Jenkins `2.440.3-lts-jdk17` (EOL May 2024), chart `5.1.12`
- **After**: Jenkins `2.541.3-lts-jdk17`, chart `5.2.0`
- **이유**: EOL 버전 사용 불가. 2026년 5월 기준 최신 LTS.
- **inbound-agent**: `3248.v65ecb_254c298-3-jdk17` → `3355.v388858a_47b_33-20-jdk17`
- **반영 위치**: `k8s-edu/Lkv1_main/helm-charts/v1.35/cicd/jenkins/` (chart), `ch4/4.5/install_jenkins.sh`

### Jenkins `update-center.json` 스냅샷 갱신

- **Before**: 2.452.1 기준 스냅샷 (2024-05-15, 플러그인 1,954개)
- **After**: 2.541.x 기준 스냅샷 (2026-05-13, 플러그인 2,073개)
- **이유**: 플러그인 버전 고정으로 강의 재현성 확보. 외부 UC가 업데이트되어도 동일 버전 설치.
- **반영 위치**: `ch4/4.5/update-center.json`

### Jenkins `wip` 브랜치 → `main` 브랜치 URL 전환

- **Before**: `sungmin/wip/ch4/4.4.1/` 경로 참조 (임시 브랜치)
- **After**: `main/ch4/4.5/` 경로 참조
- **이유**: wip 브랜치는 임시 작업용. main 브랜치의 영구 경로로 정착.
- **반영 위치**: `ch4/4.5/install_jenkins.sh`, `ch4/4.5/jenkins-config.yaml`

### Jenkins Ingress → HTTPRoute (Gateway API)

- **Before**: `controller.ingress.enabled=true`, `ingressClassName=nginx`, NodePort 32123
- **After**: `serviceType=ClusterIP`, `jenkins-httproute.yaml` 별도 적용
- **이유**: ch2 인프라가 NGINX Gateway Fabric으로 전환됨. Ingress 사용 불가.
- **접근 URL**: `http://jenkins.myk8s.local` (hosts: `192.168.1.99 jenkins.myk8s.local`)
- **반영 위치**: `ch4/4.5/install_jenkins.sh`, `ch4/4.5/jenkins-httproute.yaml` (신규)

### Jenkins `2.555.2` 시도 → 롤백 (`2.541.3` 유지)

- **시도**: update-center.json이 core version `2.555.2` 기준 스냅샷이라 버전 일치를 위해 `2.555.2-lts-jdk17`으로 변경 시도
- **결과**: Docker Hub에 `jenkins/jenkins:2.555.2-lts-jdk17` 이미지가 존재하지 않아 `ImagePullBackOff` → 실패
- **결론**: `2.541.3-lts-jdk17` 유지. update-center.json의 core version(`2.555.2`)과 실제 Jenkins 이미지 버전이 다를 수 있음 — UC 스냅샷 기준 버전은 플러그인 호환성 참고용이며 Jenkins 이미지 태그와 반드시 일치하지 않음

---

### `installLatestPlugins` 변경 이력 및 최종 결론

검증 과정에서 여러 번 변경됨:

| 변경 | 값 | 이유 | 결과 |
|---|---|---|---|
| 최초 설정 | `false` | 버전 고정 의도 | 플러그인 의존성 충족 안 됨 |
| 1차 변경 | `true` | 플러그인 설치 안 되는 버그 수정 시도 | 녹화 시점에 따라 버전 달라질 수 있음 |
| 최종 결론 | `false` + `installPlugins` 명시 | 버전 고정 + 의존성 충족 | ✅ |

**최종 설정**: `installLatestPlugins=false` + `installPlugins`에 버전 명시 (update-center.json 스냅샷 기준)

> `installLatestPlugins=false`만 쓰면 플러그인이 설치 안 되는 게 아님. `installPlugins` 목록이 있어야 그 버전대로 설치됨. Helm chart 기본 `installPlugins`의 `configuration-as-code:1775`가 너무 낮아 다른 플러그인 의존성 충족 못 함 → `2077`로 override 필수.

---

### jenkins-config.yaml — deprecated 설정 제거 + numExecutors 수정

> ⚠️ **강의자 필수 확인 사항**
>
> `jenkins-config.yaml`의 설정 변경 내용. Jenkins 2.541.3 업그레이드 과정에서 발견된 이슈.

**제거된 설정 3개** (Jenkins 2.541.3에서 deprecated/제거됨):

| 설정 | 역할 | 제거 이유 |
|---|---|---|
| `agentProtocols` (`JNLP4-connect`, `Ping`) | agent 통신 허용 프로토콜 명시 | 최신 Jenkins에서 이 방식 제거. 설정 시 JCasC가 `ConfiguratorException`을 던져 **Jenkins 자체가 기동 안 됨** |
| `myViewsTabBar` | Jenkins UI "My Views" 탭 스타일 | Deprecated. 동일하게 JCasC 초기화 실패 원인 |
| `viewsTabBar` | Jenkins UI 뷰 탭 스타일 | Deprecated. 동일 |

> 이 세 설정이 제거되지 않으면 `Failed ConfigurationAsCode.init` 오류로 Jenkins가 시작하지 못함.
> `numExecutors: 0`이 유지되던 실제 원인도 JCasC 초기화 실패 때문이었음.

**수정된 설정:**
- `numExecutors: 0` → `numExecutors: 2` (built-in executor 없으면 빌드 대기 상태 지속)

---

### install_jenkins.sh — 플러그인 설치 수정 + NFS 사전 생성

**플러그인 관련:**
- `installLatestPlugins=false` + `installPlugins` 명시로 버전 고정
- `configuration-as-code` 버전을 Helm chart 기본값 `1775` → `2077`로 override 필수
  - 기본값(`1775`)이 너무 낮아 다른 플러그인(kubernetes, workflow-aggregator 등)의 의존성 충족 못 함 → init 컨테이너 CrashLoop
- 현재 고정 버전: `kubernetes:4214`, `workflow-aggregator:596`, `git:5.2.2`, `configuration-as-code:2077`

**NFS 사전 생성 추가:**
```bash
mkdir -p /nfs_shared/dynamic-vol/default/jenkins
```
- `csi-driver-nfs`가 PVC 생성 시 NFS 디렉토리를 자동 생성해야 하는데, 일시적 상태 문제로 생성 실패하는 경우 발생
- 재설치 시에도 동일 문제 발생 가능 → 사전 생성으로 방지

---

### Jenkinsfile — `kubernetes agent` → `agent any`

> ⚠️ **강의자 필수 확인 사항**
>
> `sysnet4admin/worklog-frontend-mock` 저장소의 `Jenkinsfile` 변경 필요.

- **Before**: `agent { kubernetes { label 'jenkins-jenkins-agent' } }` — Kubernetes Pod agent 사용
- **After**: `agent any` — Built-in executor 사용
- **이유**: Hello World 단계(ch4.5)에서는 Kubernetes cloud 설정이 없어 agent pod 생성 불가. `agent any`로 built-in executor 사용이 적절.
- **참고**: ch4.6 이후 실제 Docker build가 필요한 파이프라인에서는 Kubernetes agent 또는 다른 방식 재검토 필요.

---

### Argo CD `v2.11.0` → `v3.4.2`

- **Before**: Argo CD `v2.11.0` (2.x 전체 EOL), chart `6.9.0`
- **After**: Argo CD `v3.4.2`, chart `9.5.14`
- **이유**: 2.x 시리즈 전체 EOL. 3.x가 현재 지원 라인.
- **반영 위치**: `k8s-edu/Lkv1_main/helm-charts/v1.35/cicd/argo-cd/`

---

### ch4.3~4.4 GitHub Actions 검증 완료 [2026-05-19]

**4.3 GitHub Actions Hello World:**
- `1.hello-actions_basic.yaml` ✅
- `2.hello-actions_variables.yaml` (Context, env 변수) ✅

**4.4 GitHub Actions 빌드 파이프라인:**
- `1.hello-pipeline.yaml` (test→build→deploy, `needs`) ✅
- `2.hello-pipeline_build-failure.yaml` (build 실패 → notify 실행) ✅ (의도된 실패 포함)
- `3.hello-pipeline_build-pass-variables.yaml` (Job 간 outputs 전달) ✅
- `4.hello-pipeline_build-pass-variables-failure.yaml` (Variables + 실패 분기) ✅

검증 저장소: `sysnet4admin/worklog-frontend-mock` (fork)

---

### ch4.6 Jenkins 빌드 파이프라인 검증 완료 [2026-05-19]

**4.6 Jenkins 빌드 파이프라인:**
- `1.hello-pipeline.groovy` (test→build→deploy stage) ✅ SUCCESS
- `2.hello-pipeline_build-failure.groovy` (build 실패 → post.failure 실행) ✅ FAILURE 확인 + post.failure 정상 작동
- `3.hello-pipeline_build-pass-variables.groovy` (stage 간 변수 전달) ✅ SUCCESS
- `4.hello-pipeline_build-pass-variables-function.groovy` (함수 재사용 패턴) ✅ SUCCESS

검증 저장소: `sysnet4admin/worklog-frontend-mock` (fork), Jenkins 2.541.3, `agent any` 방식
