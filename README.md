# CI/CD Learning Kit

CI/CD 실습 키트 — GitHub Actions, Jenkins, GitLab CI/CD, Argo CD를 활용한 쿠버네티스 기반 CI/CD 파이프라인 구축 강의 자료

## 사용하는 CI/CD 도구

| 도구 | 유형 | 초기 구성 | 이후 사용 |
|------|------|----------|----------|
| **GitHub Actions** | SaaS | [ch4/4.3](ch4/4.3) | ch5, ch6, ch8, ch9, ch10 |
| **Jenkins** | K8s Helm 설치 | [ch4/4.5](ch4/4.5) | ch5, ch6, ch8, ch9, ch10 |
| **GitLab CI/CD** | SaaS | [ch4/4.7](ch4/4.7) | ch5, ch6, ch8, ch9, ch10 |
| **Argo CD** | K8s Manifest 설치 | [ch6/6.2](ch6/6.2) | ch6, ch8, ch9, ch10 |

## 사용하는 배포 전략 도구

| 도구 | 유형 | 초기 구성 | 이후 사용 |
|------|------|----------|----------|
| **Argo Rollouts** | K8s 설치 | [ch7/7.4](ch7/7.4) | ch7 |

## 각 서브섹션 파일 구성

```
ch4/
├── README.md           ← 챕터 목차
└── 4.3/
    ├── .cmd            ← 실행할 명령어 스크립트 (강사/수강생용)
    ├── GUARDRAIL.md    ← AI 안내 규칙 (범위, 순서, 검증, 주의사항)
    └── *.yaml/groovy   ← 실습 파일 (파이프라인, 매니페스트)
```

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

---

### [챕터 3. Docker 빌드와 쿠버네티스로의 배포](ch3/README.md)

Worklog 샘플 앱을 Docker로 빌드하고 쿠버네티스에 수동 배포합니다.

| 섹션 | 내용 | 디렉토리 |
|------|------|---------|
| 3.2 | Worklog 앱을 다운받고 실행해보기 | [ch3/3.2](ch3/3.2) |
| 3.3 | Worklog 앱을 Docker로 컨테이너화 하기 | [ch3/3.3](ch3/3.3) |
| 3.4 | Worklog 앱을 Kubernetes에 배포하기 | [ch3/3.4](ch3/3.4) |

---

### [챕터 4. 현업에서 가장 많이 사용되는 CI/CD 도구를 찍먹하기](ch4/README.md)

GitHub Actions, Jenkins, GitLab CI/CD 3개 도구의 Hello World 파이프라인을 만들어봅니다.

| 섹션 | 내용 | 디렉토리 |
|------|------|---------|
| 4.3 | [GitHub] 파이프라인 Hello World | [ch4/4.3](ch4/4.3) |
| 4.4 | [GitHub] 빌드 파이프라인 구조 만들기 | [ch4/4.4](ch4/4.4) |
| 4.5 | [Jenkins] 파이프라인 Hello World | [ch4/4.5](ch4/4.5) |
| 4.6 | [Jenkins] 빌드 파이프라인 구조 만들기 | [ch4/4.6](ch4/4.6) |
| 4.7 | [GitLab] 파이프라인 Hello World | [ch4/4.7](ch4/4.7) |
| 4.8 | [GitLab] 빌드 파이프라인 구조 만들기 | [ch4/4.8](ch4/4.8) |

---

### [챕터 5. 빌드한 애플리케이션(CI)을 쿠버네티스에 배포(CD)하기](ch5/README.md)

실제 Docker 이미지 빌드 → Push → K8s 배포 파이프라인을 구현합니다.

| 섹션 | 내용 | 디렉토리 |
|------|------|---------|
| 5.2 | [GitHub] 빌드 파이프라인 실제로 구현하기 | [ch5/5.2](ch5/5.2) |
| 5.3 | [GitHub] Marketplace Action 활용 간소화 | [ch5/5.3](ch5/5.3) |
| 5.4 | [Jenkins] 빌드 파이프라인 실제로 구현하기 | [ch5/5.4](ch5/5.4) |
| 5.5 | [Jenkins] Plugin 활용 간소화 | [ch5/5.5](ch5/5.5) |
| 5.6 | [GitLab] 빌드 파이프라인 실제로 구현하기 | [ch5/5.6](ch5/5.6) |
| 5.7 | [GitLab] Extension 활용 간소화 | [ch5/5.7](ch5/5.7) |

---

### [챕터 6. GitOps 그리고 Argo CD](ch6/README.md)

Argo CD를 설치하고, GitOps 기반 배포 파이프라인을 구현합니다.

| 섹션 | 내용 | 디렉토리 |
|------|------|---------|
| 6.2 | Argo CD 설치 및 구성 | [ch6/6.2](ch6/6.2) |
| 6.3 | Argo CD UI 탐색 및 CLI 설치 | [ch6/6.3](ch6/6.3) |
| 6.4 | Argo CD를 이용하여 서비스 배포하기 | [ch6/6.4](ch6/6.4) |
| 6.5 | Argo CD 배포 알림 설정하기 (Slack) | [ch6/6.5](ch6/6.5) |
| 6.6 | [GitHub] Argo CD 적용해 파이프라인 구현하기 | [ch6/6.6](ch6/6.6) |
| 6.7 | [Jenkins] Argo CD 적용해 파이프라인 구현하기 | [ch6/6.7](ch6/6.7) |
| 6.8 | [GitLab] Argo CD 적용해 파이프라인 구현하기 | [ch6/6.8](ch6/6.8) |

---

### [챕터 7. K8s 기본 배포를 넘어 Argo Rollouts로 배포 전략 확장하기](ch7/README.md)

Rolling Update, Blue-Green, Canary 배포 전략을 실습합니다.

| 섹션 | 내용 | 디렉토리 |
|------|------|---------|
| 7.2 | Rolling Update, Blue-Green, Canary 등 다양한 배포 전략들 | [ch7/7.2](ch7/7.2) |
| 7.3 | Rolling Update 배포 실습 | [ch7/7.3](ch7/7.3) |
| 7.4 | Argo Rollouts 설치 및 구성 | [ch7/7.4](ch7/7.4) |
| 7.5 | Blue-Green 배포 실습 | [ch7/7.5](ch7/7.5) |
| 7.6 | Canary 배포 실습 | [ch7/7.6](ch7/7.6) |

---

### [챕터 8. 실무에 가까운 형태의 마이크로서비스 배포해보기](ch8/README.md)

Worklog App 전체 스택(Frontend + Backend + MongoDB)을 CI/CD로 배포합니다.

| 섹션 | 내용 | 디렉토리 |
|------|------|---------|
| 8.2 | Worklog App의 백엔드와 DB | [ch8/8.2](ch8/8.2) |
| 8.3 | [GitHub] Worklog App 배포해보기 | [ch8/8.3](ch8/8.3) |
| 8.4 | [Jenkins] Worklog App 배포해보기 | [ch8/8.4](ch8/8.4) |
| 8.5 | [GitLab] Worklog App 배포해보기 | [ch8/8.5](ch8/8.5) |

---

### [챕터 9. 실무에서 가장 많이 사용되는 배포 패턴 (모범 사례)](ch9/README.md)

PR/Branch/Tag 기반 멀티 환경(dev/staging/prod) 배포와 Full CI/CD 워크플로우를 구현합니다.

| 섹션 | 내용 | 디렉토리 |
|------|------|---------|
| 9.2 | 배포 환경의 중요성 (namespace 분리) | [ch9/9.2](ch9/9.2) |
| 9.3 | PR / Branch / Tag 기반 배포 패턴 | [ch9/9.3](ch9/9.3) |
| 9.4 | [GitHub] PR/Branch/Tag 기반 배포 파이프라인 만들기 | [ch9/9.4](ch9/9.4) |
| 9.5 | [GitHub] Full CI/CD workflow (Argo CD) | [ch9/9.5](ch9/9.5) |
| 9.6 | [Jenkins] PR/Branch/Tag 기반 배포 파이프라인 만들기 | [ch9/9.6](ch9/9.6) |
| 9.7 | [Jenkins] Full CI/CD workflow (Argo CD) | [ch9/9.7](ch9/9.7) |
| 9.8 | [GitLab] PR/Branch/Tag 기반 배포 파이프라인 만들기 | [ch9/9.8](ch9/9.8) |
| 9.9 | [GitLab] Full CI/CD workflow (Argo CD) | [ch9/9.9](ch9/9.9) |

---

### [챕터 10. 테라폼을 활용해 기존 환경을 클라우드 환경으로 전환하기](ch10/README.md)

Terraform으로 AWS EKS를 구성하고, 기존 CI/CD 파이프라인을 클라우드로 전환합니다.

| 섹션 | 내용 | 디렉토리 |
|------|------|---------|
| 10.2 | AWS 환경 설정하기 | [ch10/10.2](ch10/10.2) |
| 10.3 | Terraform을 이용한 EKS 배포와 삭제 | [ch10/10.3](ch10/10.3) |
| 10.4 | [공통] EKS에 Worklog App과 Argo CD 배포하기 | [ch10/10.4](ch10/10.4) |
| 10.5 | [GitHub] 기존 파이프라인을 EKS로 전환하기 | [ch10/10.5](ch10/10.5) |
| 10.6 | [Jenkins] 기존 파이프라인을 EKS로 전환하기 | [ch10/10.6](ch10/10.6) |
| 10.7 | [GitLab] 기존 파이프라인을 EKS로 전환하기 | [ch10/10.7](ch10/10.7) |

---

## [보강](A/README.md)

| 번호 | 내용 | 디렉토리 |
|------|------|---------|
| A.001 | AI 시대에 변화하는 CI/CD | [A/A.001](A/A.001) |
