# GUARDRAIL: 3.5 CI/CD 관점으로 Kubernetes 오브젝트 재이해하기

## 범위 (Scope)
### 이 단계에서 다루는 것
- 이미 알고 있는 K8s 오브젝트를 "CI/CD 맥락"으로 재해석
- 핵심 질문 3가지: Deployment / Secret / imagePullSecrets
- 파이프라인이 K8s에 배포할 때 실제로 하는 일

### 이 단계에서 다루지 않는 것
- 실제 K8s 배포 실행 (3.6에서 다룸)
- K8s 오브젝트의 기본 개념 (사전 강의 _Lecture_k8s_learning.kit에서 다룸)

## 사전 조건
- _Lecture_k8s_learning.kit 수강 완료 (Deployment, Service, Secret, Probe 이해)
- 3.4 완료 (Docker 이미지 빌드 & push 경험)

## 실행 지침

### 핵심 질문 1: 왜 Deployment인가? `[AI 프롬프트]`

매니페스트를 먼저 확인한다:
```bash
cat ~/_Lecture_cicd_learning.kit/ch3/3.6/worklog_manifests/worklog-backend.yaml
```

> "이 Deployment 매니페스트에서 `image: <dockerhub_username>/worklog-backend:buildtest1` 부분이 CI/CD에서 어떤 의미를 가지는지 설명해줘. 파이프라인이 새 버전을 배포할 때 실제로 어떤 명령을 실행하게 되는 거야?"

**강사 보충 포인트:**
- `kubectl set image deployment/worklog-backend worklog-backend=<image>:<new-tag>` = CI/CD 파이프라인의 "배포" 단계
- k8s kit에서 배운 롤링 업데이트가 바로 이 시점에 일어남
- 이미지 태그 = 버전 = 배포 단위 → "어떤 버전을 배포할지"를 파이프라인이 결정

---

### 핵심 질문 2: 왜 Secret인가? `[AI 프롬프트]`

Secret 정의와 backend에서 어떻게 참조하는지 먼저 확인한다:
```bash
cat ~/_Lecture_cicd_learning.kit/ch3/3.6/worklog_manifests/worklog-mongodb.yaml
```

base64 값 직접 디코딩:
```bash
echo "cm9vdA==" | base64 -d
echo "bXlwYXNzdzByZA==" | base64 -d
```

> "K8s Secret이 CI/CD 파이프라인 보안과 어떤 관계가 있어? 파이프라인 로그에 DB 비밀번호가 찍히는 것이 왜 위험하고, Secret이 그 문제를 어떻게 해결하는 거야?"

**강사 보충 포인트:**
- k8s kit에서 배운 Secret의 목적은 "민감 정보 분리"
- CI/CD 맥락에서는: GitHub Actions 로그 → 공개 저장소라면 누구나 볼 수 있음
- Secret은 "파이프라인(CI)과 런타임(CD) 사이의 경계선"
- 실제 실무: 파이프라인은 Secret 이름만 참조, 실제 값은 K8s가 런타임에 주입

---

### 핵심 질문 3: 왜 imagePullSecrets인가? `[AI 프롬프트]`

> "K8s가 Docker Hub에서 이미지를 pull할 때 왜 imagePullSecrets가 필요한 거야? Docker Hub의 rate limit이 뭐고, CI/CD에서 anonymous pull이 문제가 되는 이유는 뭐야?"

**강사 보충 포인트:**
- Docker Hub rate limit: 비인증 100 pull/6h, 인증 200 pull/6h, 유료 무제한
- CI/CD 환경에서는 PR마다 이미지 pull → 팀 단위로 rate limit 금방 소진
- Private registry(ECR, GCR, Harbor) 사용 시 인증 필수
- K8s가 Pod 생성 시 imagePullSecrets로 registry 인증 → `ImagePullBackOff` 방지

---

### 종합 정리 `[AI 프롬프트]`

> "이 세 가지(Deployment 이미지 태그, Secret, imagePullSecrets)가 CI/CD 파이프라인 전체 흐름에서 어떻게 연결되는지 그림으로 설명해줘"

## 주의사항
- ✅ AI가 해도 됨: 개념 설명, 실무 사례, 보안 이슈 설명
- ⛔ AI가 하지 말 것: 이 단계에서 실제 kubectl 명령 실행 (3.6에서 다룸)
- 이 섹션은 "K8s 오브젝트의 용도 재발견" — 새 내용이 아니라 관점의 전환
