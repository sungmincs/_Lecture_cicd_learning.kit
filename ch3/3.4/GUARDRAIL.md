# GUARDRAIL: 3.4 Worklog 앱 K8s 배포 및 코드 변경 후 재배포

## 범위 (Scope)
### 이 단계에서 다루는 것
- Load Balancer IP 확인
- 호스트 PC의 hosts 파일 수정
- kubectl apply로 Worklog 매니페스트 배포
- 브라우저에서 앱 접속 확인
- 코드 수정 → Docker 재빌드 → push → deployment 업데이트 흐름 체험
- 리소스 정리 (cleanup)

### 이 단계에서 다루지 않는 것
- CI/CD 자동화 (ch4 이후)
- Helm 차트 사용
- Argo CD 배포

## 사전 조건 (Prerequisites)
- ch3/3.3 완료 (Docker 이미지가 Docker Hub에 push됨)
- K8s 클러스터 가동 중
- ingress-nginx가 설치되어 있고 External IP가 192.168.1.99

## 순서 (Sequence)

### Step 1: Load Balancer IP 확인
- 명령어:
  ```bash
  kubectl get svc -n ingress-nginx ingress-nginx-controller
  ```
- 기대 결과: EXTERNAL-IP가 `192.168.1.99`인 것을 확인

### Step 2: 호스트 PC의 hosts 파일 수정
- **Windows**: 메모장을 관리자 권한으로 실행 → `C:\Windows\System32\drivers\etc\hosts` 편집
- **MacOS**: `sudo vim /etc/hosts`
- 추가할 내용:
  ```
  192.168.1.99 worklog-frontend.myk8s.local
  192.168.1.99 worklog-backend.myk8s.local
  ```
- 기대 결과: hosts 파일에 두 도메인이 등록됨

### Step 3: K8s에 Worklog 매니페스트 배포
- 명령어:
  ```bash
  kubectl apply -f ./worklog_manifests
  ```
- 기대 결과: worklog-frontend, worklog-backend, worklog-mongodb가 배포됨

### Step 4: 브라우저에서 확인
- Frontend: http://worklog-frontend.myk8s.local
- Backend (Swagger): http://worklog-backend.myk8s.local
- UI에서 항목을 추가해보기
- 기대 결과: 앱이 정상 동작

### Step 5: 코드 수정 → 재빌드 → Push
- 명령어:
  ```bash
  cd ~/workspace/worklog-frontend/
  vim src/widgets/lsb/index.tsx
  # line 46: "Summary" → "Dates" 로 변경
  docker build . -t <dockerhub_username>/worklog-frontend:buildtest2
  docker push <dockerhub_username>/worklog-frontend:buildtest2
  ```
- 기대 결과: 수정된 이미지가 buildtest2 태그로 push됨

### Step 6: Deployment 업데이트
- 명령어:
  ```bash
  kubectl edit deployment worklog-frontend
  ```
  - image 태그를 `<dockerhub_username>/worklog-frontend:buildtest2`로 변경
- 또는 매니페스트 파일 수정 후 `kubectl apply -f ./worklog_manifests`
- 기대 결과: Frontend pod가 재생성되고 변경 사항 반영

### Step 7: 변경 확인
- http://worklog-frontend.myk8s.local 접속
- 기대 결과: "Summary"가 "Dates"로 변경되어 표시됨

### Step 8: Cleanup
- 명령어:
  ```bash
  kubectl delete -f ./worklog_manifests
  ```
- 기대 결과: 배포된 리소스가 모두 삭제됨

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| LB IP | `kubectl get svc -n ingress-nginx ingress-nginx-controller` | EXTERNAL-IP: 192.168.1.99 |
| Pod 상태 | `kubectl get pods` | 모든 worklog pod가 Running 상태 |
| Frontend 접속 | http://worklog-frontend.myk8s.local | Worklog UI 표시 |
| Backend 접속 | http://worklog-backend.myk8s.local | Swagger/API 표시 |
| 재배포 확인 | http://worklog-frontend.myk8s.local | "Dates" 텍스트 확인 |
| Cleanup | `kubectl get pods` | worklog 관련 pod 없음 |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| `<dockerhub_username>` | 수강생의 Docker Hub 사용자명 | ❌ 반드시 수강생에게 확인 |

## 주의사항 (Cautions)
- ⛔ AI가 하지 말아야 할 것: `<dockerhub_username>`을 임의로 채우지 말 것
- ⛔ AI가 하지 말아야 할 것: hosts 파일을 자동으로 수정하지 말 것 — 수강생이 직접 관리자 권한으로 수정해야 함
- ⛔ AI가 하지 말아야 할 것: worklog_manifests 내의 yaml 파일을 임의로 수정하지 말 것
- ✅ AI가 해도 되는 것: `kubectl get pods` 결과 해석 및 Pod 상태 트러블슈팅 안내
- ✅ AI가 해도 되는 것: hosts 파일 위치와 편집 방법 안내 (OS별)
- ✅ AI가 해도 되는 것: `kubectl edit` 사용법 안내
