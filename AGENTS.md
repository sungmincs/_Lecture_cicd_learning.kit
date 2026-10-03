# CI/CD 실습 가이드

이 저장소는 「AI 시대에 개발자가 알아야 하는 인프라 구성 배포 with 클로드 코드」 강의의 실습 코드이다.
이 파일이 AI 에이전트 규칙의 정본이다. 특정 도구에 묶이지 않도록 공개 형식인 `AGENTS.md`에 둔다.

> **언어 규칙**: 이 강의는 한국어로 진행한다. 대화가 요약(compaction)되더라도 **반드시 한국어로 계속 진행**한다. 영어로 전환하지 않는다.

## AI 에이전트별 차이

강의 시연은 Claude Code로 하지만 규칙은 도구와 무관하다. 도구마다 다른 것은 아래 두 가지뿐이다.

| | Claude Code | Codex CLI |
|---|---|---|
| 실행 | `claude --dangerously-skip-permissions` | `codex --full-auto --sandbox danger-full-access` |
| 이 파일을 읽는 방식 | `CLAUDE.md`의 `@AGENTS.md` import | `AGENTS.md`를 직접 읽음 |

- 두 실행 방식 모두 승인 없이 명령이 실행된다. 강의는 이 방식을 기준으로 한다.
- Codex의 기본 sandbox(`workspace-write`)는 외부 네트워크를 막는다. 이 강의는 클러스터와
  컨테이너 레지스트리에 접근하므로 네트워크 허용이 필요하다.
- 다른 AI 에이전트를 쓸 때도 이 파일을 규칙으로 읽게 하면 된다. 대부분 `AGENTS.md`를 직접 읽는다.
- `CLAUDE.md`는 `@AGENTS.md` 한 줄만 둔다. 규칙을 그쪽에 옮겨 적지 않는다.

## 핵심 안전 규칙

- 비밀값을 커밋하지 않는다. Docker Hub 토큰, GitHub·GitLab 액세스 토큰, AWS 액세스 키가 이
  강의에 모두 나온다. 커밋하면 push할 때 그대로 올라가고 이력에 남아 지워도 되돌릴 수 없다.
  Secret은 클러스터에 직접 만들고 매니페스트는 참조만 한다.
- AWS 리소스는 요청받은 것만 만든다. 10장의 EKS는 켜 둔 시간만큼 과금되므로 실습을 마치면
  `terraform destroy`로 지웠는지 확인한다.

## 가드레일 설정

아래 `mode` 값에 따라 동작한다. 값이 `(미설정)`이면 독자에게 선택지를 보여주고, 선택 후 이 파일의 mode 값을 업데이트한다.

mode: auto

| mode | 동작 |
|------|------|
| `auto` | 독자가 입력하면 자동으로 가드레일 파일을 참조하여 실행한다 |
| `off` | 가드레일 없이 독자의 입력만으로 자유롭게 실행한다 |
| `ask` | 매번 "가드레일을 참조할까요?"라고 물어본다 |

> 독자가 "가드레일 모드 변경해줘"라고 말하면 이 값을 업데이트한다.

## 독자 입력 → 참조 파일 매칭

독자가 자연어로 입력하면 아래 테이블에서 가장 가까운 항목을 찾아 유형에 맞는 참조 파일을 사용한다.

**유형 설명:**
- **탐색**: "뭘 쓰면 돼?", "어떤 방법이 있어?", "이게 뭐야?" → 해당 챕터의 개요 가드레일(`prompt-guardrails/chN/N.2-*.md` 등)을 참조하여 개념·추천·이유 설명
- **실행**: "그걸로 진행해줘", "설치해줘", "만들어줘" → `prompt-guardrails/` 파일의 `## 실행 지침`을 따라 작업

### [강의 작성됨] 2장: CI/CD 실습 환경 구성

| 학습자 입력 예시 | 유형 | 참조 파일 |
|---------------|------|-----------|
| VirtualBox, Vagrant, Tabby 설치해줘 | 실행 | `prompt-guardrails/ch2/2.3-tools-install.md` |
| 모든 노드에 Docker 설치해줘 | 실행 | `prompt-guardrails/ch2/2.11-docker-all-nodes.md` |
| 이 저장소 규칙이 어떻게 돼 있어? / 가드레일이 뭐야? / Claude Code 설치해줘 | 탐색 | `prompt-guardrails/ch2/2.12-ai-agent-harness.md` |

### [강의 작성됨] 3장: Docker 빌드와 쿠버네티스로의 배포

| 학습자 입력 예시 | 유형 | 참조 파일 |
|---------------|------|-----------|
| 이 장에서 뭘 해? worklog 앱이 뭐야? 컨테이너화/배포 흐름 설명해줘 | 탐색 | `prompt-guardrails/ch3/3.2-containerization-overview.md` |
| Worklog 앱 받아서 실행해줘 | 실행 | `prompt-guardrails/ch3/3.3-worklog-download.md` |
| Dockerfile이 어떻게 생겼어? 멀티스테이지 빌드 설명해줘 | 실행 | `prompt-guardrails/ch3/3.4-dockerfile-analysis.md` |
| Docker로 빌드하고 Docker Hub에 push해줘 | 실행 | `prompt-guardrails/ch3/3.5-docker-build.md` |
| 쿠버네티스에 배포해줘 | 실행 | `prompt-guardrails/ch3/3.6-k8s-deploy.md` |
| CI/CD 관점으로 Deployment, Secret, imagePullSecrets 설명해줘 | 실행 | `prompt-guardrails/ch3/3.7-k8s-cicd-perspective.md` |
| 이미지 업데이트하고 재배포해줘 / buildtest2로 바꿔줘 | 실행 | `prompt-guardrails/ch3/3.8-image-update.md` |
| Pod 오류 진단해줘 / ImagePullBackOff / CrashLoopBackOff / readinessProbe | 실행 | `prompt-guardrails/ch3/3.9-troubleshooting.md` |

### [강의 작성됨] 4장: CI/CD 도구 구조부터 먼저

| 학습자 입력 예시 | 유형 | 참조 파일 |
|---------------|------|-----------|
| CI/CD 도구 뭐가 있어? 비교해줘 / 어떤 걸 써야 해? | 탐색 | `prompt-guardrails/ch4/4.2-cicd-tools-overview.md` |
| GitHub Actions 워크플로우 만들어줘 | 실행 | `prompt-guardrails/ch4/4.3-github-actions-hello.md` |
| GitHub Actions 빌드 파이프라인 만들어줘 | 실행 | `prompt-guardrails/ch4/4.4-github-actions-pipeline.md` |
| Jenkins 설치해줘 | 실행 | `prompt-guardrails/ch4/4.5-jenkins-install.md` |
| Jenkins 파이프라인 만들어줘 | 실행 | `prompt-guardrails/ch4/4.6-jenkins-pipeline.md` |

### [강의 작성됨] 5장: CI 파이프라인 구현: 빌드한 이미지를 레지스트리에 올리기

| 학습자 입력 예시 | 유형 | 참조 파일 |
|---------------|------|-----------|
| CI랑 CD가 어떻게 연결돼? 빌드 결과를 배포로 잇는 흐름 설명해줘 | 탐색 | `prompt-guardrails/ch5/5.2-ci-to-cd-overview.md` |
| GitHub로 Docker 빌드하고 배포하는 파이프라인 만들어줘 | 실행 | `prompt-guardrails/ch5/5.3-github-actions-build-deploy.md` |
| Marketplace Action으로 간소화해줘 | 실행 | `prompt-guardrails/ch5/5.4-github-actions-marketplace.md` |
| Jenkins로 Docker 빌드 파이프라인 만들어줘 | 실행 | `prompt-guardrails/ch5/5.5-jenkins-build-deploy.md` |
| Jenkins Docker Plugin으로 간소화해줘 | 실행 | `prompt-guardrails/ch5/5.6-jenkins-plugin.md` |

### [강의 작성됨] 6장: GitOps와 Argo CD

| 학습자 입력 예시 | 유형 | 참조 파일 |
|---------------|------|-----------|
| GitOps가 뭐야? Argo CD는 왜 써? 선언적 배포 설명해줘 | 탐색 | `prompt-guardrails/ch6/6.2-gitops-overview.md` |
| Argo CD 설치해줘 | 실행 | `prompt-guardrails/ch6/6.3-argocd-install.md` |
| Argo CD UI 탐색하고 CLI 설치해줘 | 실행 | `prompt-guardrails/ch6/6.4-argocd-ui-cli.md` |
| Argo CD로 worklog-backend 배포해줘 | 실행 | `prompt-guardrails/ch6/6.5-argocd-application.md` |
| Argo CD 배포 알림 설정해줘 | 실행 | `prompt-guardrails/ch6/6.6-argocd-notification.md` |
| GitHub Actions에 Argo CD 연동해줘 | 실행 | `prompt-guardrails/ch6/6.7-github-argocd-pipeline.md` |
| Jenkins에 Argo CD 연동해줘 | 실행 | `prompt-guardrails/ch6/6.8-jenkins-argocd-pipeline.md` |

### [강의 작성됨] 7장: 실무 배포 전략을 배우고 이를 마이크로서비스에 적용하기

| 학습자 입력 예시 | 유형 | 참조 파일 |
|---------------|------|-----------|
| 배포 전략 뭐가 있어? Rolling/Blue-Green/Canary 차이 설명해줘 | 탐색 | `prompt-guardrails/ch7/7.2-deployment-strategies.md` |
| Rolling Update 배포 실습해줘 | 실행 | `prompt-guardrails/ch7/7.3-rolling-update.md` |
| Argo Rollouts 설치해줘 | 실행 | `prompt-guardrails/ch7/7.4-argo-rollouts-install.md` |
| Blue-Green 배포 실습해줘 | 실행 | `prompt-guardrails/ch7/7.5-bluegreen.md` |
| Canary 배포 실습해줘 | 실행 | `prompt-guardrails/ch7/7.6-canary.md` |
| worklog 전체 스택 매니페스트 적용해줘 | 실행 | `prompt-guardrails/ch7/7.7-fullstack-manifest.md` |
| GitHub로 frontend/backend 배포 파이프라인 만들어줘 | 실행 | `prompt-guardrails/ch7/7.8-github-fullstack-pipeline.md` |
| Jenkins로 frontend/backend 배포 파이프라인 만들어줘 | 실행 | `prompt-guardrails/ch7/7.9-jenkins-fullstack-pipeline.md` |

### [강의 작성됨] 8장: 실무에서 가장 많이 사용되는 배포 패턴 (모범 사례)

| 학습자 입력 예시 | 유형 | 참조 파일 |
|---------------|------|-----------|
| 멀티환경 배포가 뭐야? namespace/브랜치 패턴 설명해줘 | 탐색 | `prompt-guardrails/ch8/8.2-multi-env-patterns.md` |
| GitHub로 PR/develop/release/tag 별 멀티 환경 파이프라인 만들어줘 | 실행 | `prompt-guardrails/ch8/8.3-github-multi-env.md` |
| GitHub Full CI/CD에 Argo CD까지 연동해줘 | 실행 | `prompt-guardrails/ch8/8.4-github-full-cicd.md` |
| Jenkins로 멀티환경 파이프라인 만들어줘 | 실행 | `prompt-guardrails/ch8/8.5-jenkins-multi-env.md` |
| Jenkins Full CI/CD에 Argo CD 연동해줘 | 실행 | `prompt-guardrails/ch8/8.6-jenkins-full-cicd.md` |

### [강의 작성됨] 9장: CI/CD 강화 — 품질과 보안 게이트 구축하기

| 학습자 입력 예시 | 유형 | 참조 파일 |
|---------------|------|-----------|
| CI/CD 강화가 왜 필요한지 설명해줘 | 탐색 | `prompt-guardrails/ch9/9.2-cicd-gate-overview.md` |
| 파이프라인에 lint 추가해줘 | 실행 | `prompt-guardrails/ch9/9.3-lint.md` |
| 보안 취약점 스캔 추가해줘 | 실행 | `prompt-guardrails/ch9/9.4-security-scan.md` |
| 테스트 커버리지 임계값 설정해줘 | 실행 | `prompt-guardrails/ch9/9.5-coverage.md` |
| 이미지 취약점 스캔 추가해줘 | 실행 | `prompt-guardrails/ch9/9.6-trivy.md` |
| prod 수동 승인 게이트 설정해줘 | 실행 | `prompt-guardrails/ch9/9.7-prod-approval.md` |
| 자동 롤백 설정해줘 | 실행 | `prompt-guardrails/ch9/9.8-auto-rollback.md` |

### [강의 작성됨] 10장: Terraform으로 클라우드 전환하고 GitLab CI로 인프라까지 관리하기

| 학습자 입력 예시 | 유형 | 참조 파일 |
|---------------|------|-----------|
| 클라우드로 왜/어떻게 옮겨? 로컬 vs EKS 차이 설명해줘 | 탐색 | `prompt-guardrails/ch10/10.2-cloud-migration-overview.md` |
| AWS 환경 설정해줘 | 실행 | `prompt-guardrails/ch10/10.3-aws-setup.md` |
| Terraform으로 EKS 배포해줘 | 실행 | `prompt-guardrails/ch10/10.4-terraform-eks.md` |
| EKS에 worklog 앱이랑 Argo CD 배포해줘 | 실행 | `prompt-guardrails/ch10/10.5-eks-worklog-argocd.md` |
| GitHub Actions를 EKS로 전환해줘 | 실행 | `prompt-guardrails/ch10/10.6-github-eks-pipeline.md` |
| Jenkins를 EKS로 전환해줘 | 실행 | `prompt-guardrails/ch10/10.7-jenkins-eks-pipeline.md` |
| GitLab CI는 뭐가 달라? GitHub Actions·Jenkins와 비교해줘 | 탐색 | `prompt-guardrails/ch10/10.8-gitlab-overview.md` |
| GitLab CI로 빌드하고 Argo CD로 EKS에 배포해줘 | 실행 | `prompt-guardrails/ch10/10.9-gitlab-ci-argocd.md` |
| Terraform state를 GitLab으로 옮겨줘 / GitLab 파이프라인으로 EKS 정리해줘 | 실행 | `prompt-guardrails/ch10/10.10-gitlab-terraform-state.md` |

### [강의 작성됨] 부록 A: 보강

| 학습자 입력 예시 | 유형 | 참조 파일 |
|---------------|------|-----------|
| AI가 만든 코드에 맞게 CI/CD를 강화해줘 / AI 시대에 CI/CD는 어떻게 바뀌어? | 실행 | `prompt-guardrails/A/A.001-ai-era-cicd.md` |

## 실행 규칙

### 공통 참조 파일 (`prompt-guardrails/shared/`)

| 파일 | 역할 | 참조 시점 |
|------|------|----------|
| `compatible-versions.md` | 검증된 도구 버전 조합 | 코드/매니페스트 생성 시 버전 참조 |

### 챕터 구조 (개요 → 개념/준비 → 실습)

각 챕터는 다음 구조로 균일하게 구성된다:

- **x.1 개요**: 챕터 전체 도입(본문, 산출물 없음)
- **x.2 개념/준비**: 그 챕터에 필요한 개념 설명 또는 사전 준비(pre-requirement). `prompt-guardrails/chN/N.2-*.md`로 제공되며, 독자의 "이게 뭐야?"(탐색) 질문에 응답한다.
- **x.3~ 실습**: 실제 도구별 구현. `prompt-guardrails/chN/N.M-*.md`의 `## 실행 지침`을 따른다.

> 독자가 개념 단계를 건너뛰고 바로 "Argo CD 설치해줘"라고 하면 즉시 실행 단계로 진입한다. 개요→개념→실습은 권장 흐름이지 강제가 아니다.

### kubectl 안전 규칙

> **[강의 표준]** 본 강의는 Vagrant + VirtualBox 기반 로컬 K8s 클러스터에서 실습합니다.
> - 학습자는 호스트에서 `ssh root@192.168.1.10`(비밀번호 `vagrant`)로 control plane 노드에 접속
> - kubectl은 **control plane 노드 안에서 root 사용자로** 실행
> - 호스트 머신에서 직접 cluster를 다루지 않음
> - 단일 클러스터 환경이라 책처럼 `--context` 강제 불필요. 단, 학습자가 여러 클러스터(예: ch10의 EKS) 추가 시점부터는 context 명시 권장.
>
> 이 강의는 AI 에이전트를 승인 없이 명령이 실행되는 모드로 쓴다(위 "AI 에이전트별 차이"). 그러므로 kubectl이 잘못된 클러스터를 대상으로 동작하지 않도록 주의한다. ch10에서 EKS를 추가한 뒤에는 `kubectl config use-context` 또는 `--context`로 대상 클러스터를 명시한다.

### 공통 실행 규칙

1. 독자가 입력하면, mode에 따라 가드레일 참조 여부를 결정한다.
2. 가드레일을 참조하는 경우:
   - `prompt-guardrails/` 파일의 `## 사전 조건`이 있으면 먼저 확인한다.
   - `## 실행 지침`을 따라 작업을 수행한다.
   - 에러가 발생하면 `## 트러블슈팅`을 참고하여 해결한다.
3. 작업 완료 후, 대응하는 `result-templates/` 파일이 있으면 읽어서 실제 결과와 비교하여 보여준다.
   - 예: `prompt-guardrails/ch3/3.3-worklog-download.md` → `result-templates/ch3/3.3-verify.md`
   - 체크리스트 항목을 하나씩 검증한다.
4. `💬 질문` 블록이 있으면 독자에게 "이런 질문을 해볼 수 있습니다"라고 안내한다.

## 프로젝트 컨텍스트

- **앱**: Worklog — 업무 기록 관리 앱 (frontend + backend + MongoDB)
- **언어**: backend Python(uv), frontend Node(Vite)
- **컨테이너**: backend `python:3.14-bookworm-slim`(uv), frontend `node:24-bookworm-slim`, DB `mongo:8.0`
- **인프라**: Vagrant + VirtualBox 기반 로컬 K8s (cp-k8s 1대 + worker 3대, K8s 1.35.2, containerd 2.2.2)
- **외부 노출**: NGINX Gateway Fabric v2.3.0 (Gateway API, LB 192.168.1.99)
- **CI/CD 도구**: GitHub Actions / Jenkins(2.541.3) 2종을 ch4~ch10에서 병행. GitLab CI는 ch10 후반(10.8~10.10)에서 EKS 위에서 다룬다
- **GitOps**: Argo CD v3.4.3 (+ Argo Rollouts v1.9.0)
- **배포 전략**: Rolling → Blue/Green → Canary (ch7)
- **클라우드 전환**: Terraform + AWS EKS (ch10). EKS는 10.4에서 만들어 10.10에서 GitLab 파이프라인으로 지운다

> 정확한 버전 조합은 `prompt-guardrails/shared/compatible-versions.md`를 단일 출처로 참조한다.

## 학습자 작업 저장소 위치

학습자는 `sungmincs/worklog-*`를 본인 계정으로 **fork**한 뒤 control plane 노드의 `/root/workspace/`에 clone하여 작업한다.
