# GUARDRAIL: 3.6 Kubernetes에 Worklog 앱 배포하기

## 범위 (Scope)
### 이 단계에서 다루는 것
- `kubectl apply`로 worklog 스택 전체 배포 (backend + frontend + mongodb)
- Pod 상태 확인 및 접속 테스트
- hosts 파일 설정 (로컬 도메인 접근)

### 이 단계에서 다루지 않는 것
- 이미지 업데이트 후 재배포 (3.7에서 다룸)
- CI/CD 파이프라인 자동화 (ch4~에서 다룸)

## 사전 조건
- 3.5 완료 (CI/CD 관점 K8s 오브젝트 이해)
- 3.4에서 빌드한 이미지가 Docker Hub에 push된 상태
- worklog_manifests 내 `<dockerhub_username>` 플레이스홀더 교체 완료

## 실행 지침

### 단계 0: 매니페스트 이미지 태그 수정 `[AI 프롬프트]`

배포 전에 매니페스트의 `<dockerhub_username>`을 본인 ID로 교체:

> "ch3/3.6/worklog_manifests/ 아래 yaml 파일들에서 `<dockerhub_username>`을 내 Docker Hub ID인 `홍길동`으로 바꿔줘"

### 단계 1: Worklog 앱 배포 `[학습자 직접]`

```bash
cd ~/_Lecture_cicd_learning.kit/ch3/3.6
kubectl apply -f ./worklog_manifests
```

### 단계 2: 배포 상태 확인 `[학습자 직접]`

```bash
kubectl get pods -w
```

Pod가 Running 상태가 되면 Ctrl+C로 watch 중단

> "Pod 상태가 `Pending`에서 `Running`으로 바뀌는 과정에서 K8s 내부에서 어떤 일이 일어나는 거야?"

### 단계 3: 앱 접속 확인 `[학습자 직접]`

브라우저에서:
- `http://worklog-frontend.myk8s.local` → UI 확인
- `http://worklog-backend.myk8s.local/docs` → Swagger API 문서 확인

UI에서 worklog 항목 몇 개 추가 후 새로고침으로 DB 연동 확인

### 단계 4: 배포 구조 이해 `[AI 프롬프트]`

> "지금 배포한 worklog 스택에서 frontend → backend → mongodb가 어떻게 연결되어 있는지 설명해줘. 각 컴포넌트 사이의 통신 경로가 뭐야?"

## 주의사항
- ✅ AI가 해도 됨: 이미지 태그 교체, 배포 구조 설명, 오류 원인 분석
- ⛔ 학습자가 직접 해야 함: `kubectl apply`, 브라우저 접속 확인
- ImagePullBackOff 발생 시 → 3.8 트러블슈팅 가이드 참고
- 이 단계 배포는 3.7(이미지 업데이트)에서 계속 사용 → cleanup 하지 말 것
