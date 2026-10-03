# CI/CD Learning Kit

CI/CD 실습 키트 — GitHub Actions, Jenkins, GitLab CI/CD, Argo CD를 활용한 쿠버네티스 기반 CI/CD 파이프라인 구축 강의 자료

## 사용하는 CI/CD 도구

| 도구 | 유형 | 초기 구성 | 이후 사용 |
|------|------|----------|----------|
| **GitHub Actions** | SaaS | [ch4/4.3](ch4/4.3) | ch5, ch6, ch7, ch8, ch9, ch10 |
| **Jenkins** | K8s Helm 설치 | [ch4/4.5](ch4/4.5) | ch5, ch6, ch7, ch8, ch9, ch10 |
| **GitLab CI/CD** | SaaS | [ch10/10.9](ch10/10.9) | ch10 (EKS 위에서, Terraform state 관리까지) |
| **Argo CD** | K8s Manifest 설치 | [ch6/6.3](ch6/6.3) | ch6, ch8, ch9, ch10 |

## 사용하는 배포 전략 도구

| 도구 | 유형 | 초기 구성 | 이후 사용 |
|------|------|----------|----------|
| **Argo Rollouts** | K8s 설치 | [ch7/7.4](ch7/7.4) | ch7 |

## 각 서브섹션 파일 구성

```
prompt-guardrails/
└── ch4/
    └── 4.3-github-actions-hello.md   ← AI 안내 규칙 (사전 조건, 실행 지침, 주의사항)

ch4/
├── README.md           ← 챕터 목차
└── 4.3/
    ├── .cmd            ← 실행할 명령어 스크립트 (강사/수강생용)
    └── *.yaml/groovy   ← 정답 파일 (파이프라인, 매니페스트)
```

> AI 안내 규칙은 `prompt-guardrails/`가 정본이다. `chN/N.M/`에는 실습 정답 파일만 둔다.

---

## 목차

### 챕터 1. AI 시대에 CI/CD의 가치와 전망
> 이론 중심 — 실습 파일 없음

- 1.1 이번 챕터에서는..
- 1.2 컨테이너와 클라우드가 가져온 개발방식의 변화
- 1.3 CI/CD란
- 1.4 GitOps란 (개념 소개)
- 1.5 AI 시대에 CI/CD 개발 방식의 변화

---

### [챕터 2. CI/CD 실습환경 구성](ch2/README.md)

로컬 머신에 Vagrant + VirtualBox로 쿠버네티스 클러스터를 구축합니다.

| 섹션 | 내용 | 디렉토리 |
|------|------|---------|
| 2.3 | Vagrant + VirtualBox로 K8s 환경 구축 (x86-64/amd64) | [ch2/2.3](ch2/2.3) |
| 2.4 | Vagrant + VirtualBox로 K8s 환경 구축 (arm64) | [ch2/2.4](ch2/2.4) |
| 2.11 | Docker를 모든 노드에 설치 | [ch2/2.11](ch2/2.11) |
| 2.12 | Claude Code와 실습 하네스 구조 | [prompt-guardrails/ch2/2.12-ai-agent-harness.md](prompt-guardrails/ch2/2.12-ai-agent-harness.md) |

---

### [챕터 3. Docker 빌드와 쿠버네티스로의 배포](ch3/README.md)

Worklog 샘플 앱을 Docker로 빌드하고 쿠버네티스에 수동 배포합니다.

| 섹션 | 내용 | 디렉토리 |
|------|------|---------|
| 3.2 | 컨테이너화와 쿠버네티스 배포 개요 (worklog 앱 소개) | [prompt-guardrails/ch3/3.2-containerization-overview.md](prompt-guardrails/ch3/3.2-containerization-overview.md) |
| 3.3 | Worklog 앱을 다운받고 실행해보기 | [ch3/3.3](ch3/3.3) |
| 3.4 | Worklog 앱의 Dockerfile 이해하기 | [prompt-guardrails/ch3/3.4-dockerfile-analysis.md](prompt-guardrails/ch3/3.4-dockerfile-analysis.md) |
| 3.5 | Docker 이미지 빌드 및 Docker Hub push | [ch3/3.5](ch3/3.5) |
| 3.6 | Worklog 앱을 Kubernetes에 배포하기 | [ch3/3.6](ch3/3.6) |
| 3.7 | CI/CD 관점으로 Kubernetes 오브젝트 재이해하기 | [prompt-guardrails/ch3/3.7-k8s-cicd-perspective.md](prompt-guardrails/ch3/3.7-k8s-cicd-perspective.md) |
| 3.8 | 이미지 업데이트와 수동 재배포 — 왜 CI/CD가 필요한가 | [prompt-guardrails/ch3/3.8-image-update.md](prompt-guardrails/ch3/3.8-image-update.md) |
| 3.9 | CI/CD 특화 트러블슈팅 | [prompt-guardrails/ch3/3.9-troubleshooting.md](prompt-guardrails/ch3/3.9-troubleshooting.md) |

---

### [챕터 4. CI/CD 도구 구조부터 먼저](ch4/README.md)

GitHub Actions와 Jenkins 두 도구의 Hello World 파이프라인을 만들어봅니다.

| 섹션 | 내용 | 디렉토리 |
|------|------|---------|
| 4.2 | CI/CD 도구 개요와 선택 | [prompt-guardrails/ch4/4.2-cicd-tools-overview.md](prompt-guardrails/ch4/4.2-cicd-tools-overview.md) |
| 4.3 | [GitHub] 파이프라인 Hello World | [ch4/4.3](ch4/4.3) |
| 4.4 | [GitHub] 빌드 파이프라인 구조 만들기 | [ch4/4.4](ch4/4.4) |
| 4.5 | [Jenkins] 파이프라인 Hello World | [ch4/4.5](ch4/4.5) |
| 4.6 | [Jenkins] 빌드 파이프라인 구조 만들기 | [ch4/4.6](ch4/4.6) |

---

### [챕터 5. CI 파이프라인 구현: 빌드한 이미지를 레지스트리에 올리기](ch5/README.md)

GitHub Actions / Jenkins로 실제 Docker 이미지 빌드 → 테스트 → Docker Hub push까지의 CI 파이프라인을 구현합니다. 클러스터 배포(CD)는 ch6에서 Argo CD(GitOps)로 다룹니다.

| 섹션 | 내용 | 디렉토리 |
|------|------|---------|
| 5.2 | CI에서 CD로 — 빌드 산출물을 배포로 연결하기 | [prompt-guardrails/ch5/5.2-ci-to-cd-overview.md](prompt-guardrails/ch5/5.2-ci-to-cd-overview.md) |
| 5.3 | [GitHub] 빌드 파이프라인 실제로 구현하기 | [ch5/5.3](ch5/5.3) |
| 5.4 | [GitHub] Marketplace Action 활용 간소화 | [ch5/5.4](ch5/5.4) |
| 5.5 | [Jenkins] 빌드 파이프라인 실제로 구현하기 | [ch5/5.5](ch5/5.5) |
| 5.6 | [Jenkins] Plugin 활용 간소화 | [ch5/5.6](ch5/5.6) |

---

### [챕터 6. GitOps 그리고 Argo CD](ch6/README.md)

Argo CD를 설치하고, GitOps 기반 배포 파이프라인을 구현합니다.

| 섹션 | 내용 | 디렉토리 |
|------|------|---------|
| 6.2 | GitOps 개념과 Argo CD (왜 선언적 배포인가) | [prompt-guardrails/ch6/6.2-gitops-overview.md](prompt-guardrails/ch6/6.2-gitops-overview.md) |
| 6.3 | Argo CD 설치 및 구성 | [ch6/6.3](ch6/6.3) |
| 6.4 | Argo CD UI 탐색 및 CLI 설치 | [ch6/6.4](ch6/6.4) |
| 6.5 | Argo CD를 이용하여 서비스 배포하기 | [ch6/6.5](ch6/6.5) |
| 6.6 | Argo CD 배포 알림 설정하기 (Slack) | [ch6/6.6](ch6/6.6) |
| 6.7 | [GitHub] Argo CD 적용해 파이프라인 구현하기 | [ch6/6.7](ch6/6.7) |
| 6.8 | [Jenkins] Argo CD 적용해 파이프라인 구현하기 | [ch6/6.8](ch6/6.8) |

---

### [챕터 7. 실무 배포 전략과 마이크로서비스 적용](ch7/README.md)

Rolling Update, Blue-Green, Canary 배포 전략을 실습합니다.

| 섹션 | 내용 | 디렉토리 |
|------|------|---------|
| 7.2 | 배포 전략 개요 (Rolling Update / Blue-Green / Canary) | [prompt-guardrails/ch7/7.2-deployment-strategies.md](prompt-guardrails/ch7/7.2-deployment-strategies.md) |
| 7.3 | Rolling Update 배포 실습 | [ch7/7.3](ch7/7.3) |
| 7.4 | Argo Rollouts 설치 및 구성 | [ch7/7.4](ch7/7.4) |
| 7.5 | Blue-Green 배포 실습 | [ch7/7.5](ch7/7.5) |
| 7.6 | Canary 배포 실습 | [ch7/7.6](ch7/7.6) |
| 7.7 | worklog 전체 스택 매니페스트 적용 | [ch7/7.7](ch7/7.7) |
| 7.8 | [GitHub] frontend/backend 배포 파이프라인 | [ch7/7.8](ch7/7.8) |
| 7.9 | [Jenkins] frontend/backend 배포 파이프라인 | [ch7/7.9](ch7/7.9) |

---

### [챕터 8. 실무에서 가장 많이 사용되는 배포 패턴 (모범 사례)](ch8/README.md)

PR/Branch/Tag 기반 멀티 환경(dev/staging/prod) 배포와 Full CI/CD(Argo CD 자동 sync) 워크플로우를 GitHub Actions/Jenkins로 각각 구현합니다.

| 섹션 | 내용 | 디렉토리 |
|------|------|---------|
| 8.2 | 멀티환경 배포의 개념 (namespace 분리 + PR/Branch/Tag 패턴) | [prompt-guardrails/ch8/8.2-multi-env-patterns.md](prompt-guardrails/ch8/8.2-multi-env-patterns.md) |
| 8.3 | [GitHub] PR/Branch/Tag 기반 멀티환경 파이프라인 | [ch8/8.3](ch8/8.3) |
| 8.4 | [GitHub] Full CI/CD workflow (Argo CD) | [ch8/8.4](ch8/8.4) |
| 8.5 | [Jenkins] PR/Branch/Tag 기반 멀티환경 파이프라인 | [ch8/8.5](ch8/8.5) |
| 8.6 | [Jenkins] Full CI/CD workflow (Argo CD) | [ch8/8.6](ch8/8.6) |

---

### [챕터 9. CI/CD 강화 — 품질과 보안 게이트 구축하기](ch9/README.md)

ch8에서 구축한 멀티환경 파이프라인에 lint·보안 스캔·커버리지·이미지 취약점 게이트와 prod 수동 승인·자동 롤백을 더해 품질과 보안을 강화합니다.

| 섹션 | 내용 | 디렉토리 |
|------|------|---------|
| 9.2 | AI 시대에 변화하는 CI/CD (개요) | [prompt-guardrails/ch9/9.2-cicd-gate-overview.md](prompt-guardrails/ch9/9.2-cicd-gate-overview.md) |
| 9.3 | CI 강화 - Lint (ruff) | [ch9/9.3](ch9/9.3) |
| 9.4 | CI 강화 - Security Scan (pip-audit, gitleaks) | [ch9/9.4](ch9/9.4) |
| 9.5 | CI 강화 - Test Coverage 임계값 | [ch9/9.5](ch9/9.5) |
| 9.6 | CD 강화 - 이미지 취약점 스캔 (Trivy) | [ch9/9.6](ch9/9.6) |
| 9.7 | CD 강화 - prod 수동 승인 게이트 | [ch9/9.7](ch9/9.7) |
| 9.8 | CD 강화 - 자동 롤백 (Argo Rollouts AnalysisTemplate) | [ch9/9.8](ch9/9.8) |

---

### [챕터 10. Terraform으로 클라우드 전환하고 GitLab CI로 인프라까지 관리하기](ch10/README.md)

Terraform으로 AWS EKS를 구성하고 기존 CI/CD 파이프라인을 클라우드로 전환합니다. 이어서 같은 EKS 위에서 GitLab CI가 무엇이 다른지 보고, Terraform state까지 GitLab에 맡겨 인프라를 파이프라인으로 관리합니다.

| 섹션 | 내용 | 디렉토리 |
|------|------|---------|
| 10.2 | 클라우드 전환 개요 (로컬 K8s → AWS EKS) | [prompt-guardrails/ch10/10.2-cloud-migration-overview.md](prompt-guardrails/ch10/10.2-cloud-migration-overview.md) |
| 10.3 | AWS 환경 설정하기 | [ch10/10.3](ch10/10.3) |
| 10.4 | Terraform을 이용한 EKS 배포 | [ch10/10.4](ch10/10.4) |
| 10.5 | [공통] EKS에 Worklog App과 Argo CD 배포하기 | [ch10/10.5](ch10/10.5) |
| 10.6 | [GitHub] 기존 파이프라인을 EKS로 전환하기 | [ch10/10.6](ch10/10.6) |
| 10.7 | [Jenkins] 기존 파이프라인을 EKS로 전환하기 | [ch10/10.7](ch10/10.7) |
| 10.8 | GitLab CI는 무엇이 다른가 | [prompt-guardrails/ch10/10.8-gitlab-overview.md](prompt-guardrails/ch10/10.8-gitlab-overview.md) |
| 10.9 | [GitLab] 실습 1: CI로 빌드하고 Argo CD로 EKS에 배포하기 | [ch10/10.9](ch10/10.9) |
| 10.10 | [GitLab] 실습 2: Terraform state를 GitLab에 맡기고 파이프라인으로 EKS 정리하기 | [ch10/10.10](ch10/10.10) |

---

## [보강](A/README.md)

| 번호 | 내용 | 디렉토리 |
|------|------|---------|
| A.001 | AI 시대에 변화하는 CI/CD | [A/A.001](A/A.001) |
