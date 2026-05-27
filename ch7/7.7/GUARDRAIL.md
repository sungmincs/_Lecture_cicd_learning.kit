# GUARDRAIL: 7.7 Worklog App의 백엔드와 DB

## 범위 (Scope)
### 이 단계에서 다루는 것
- Worklog App 마이크로서비스 아키텍처 이해 (Frontend + Backend + MongoDB)
- MongoDB 배포 (Secret, Deployment, Service)
- Backend 배포 및 MongoDB 연결 설정
- Frontend 배포 및 Backend 연결 설정
- 전체 스택 통합 검증

### 이 단계에서 다루지 않는 것
- CI/CD 파이프라인을 통한 자동 배포 (7.8~7.10에서 다룸)
- PersistentVolume을 활용한 MongoDB 데이터 영속성
- MongoDB ReplicaSet 구성

## 사전 조건 (Prerequisites)
- ch5 완료 (CI/CD 파이프라인 기본 구성)
- ch6 완료 (Argo CD 설치 및 구성)
- Docker Hub에 worklog-backend, worklog-frontend 이미지가 push된 상태
- Kubernetes 클러스터에 Ingress Controller(nginx) 설치 완료

## 순서 (Sequence)
### Step 1: MongoDB 배포 [학습자 직접]
- 명령어: `kubectl apply -f 1.mongodb-manifest.yaml`
- 기대 결과: mongodb Pod Running, mongodb Service 생성

### Step 2: MongoDB 동작 확인 [학습자 직접]
- 명령어: `kubectl get pods -l app=mongodb`
- 명령어: `kubectl get svc mongodb`
- 기대 결과: Pod Running, Service port 27017

### Step 3: Backend 배포 [AI 프롬프트]
- 명령어: `kubectl apply -f 2.worklog-backend-with-db.yaml`
- 기대 결과: worklog-backend Pod Running, MongoDB 연결 성공

### Step 4: Backend 로그 확인 [학습자 직접]
- 명령어: `kubectl logs -l app=worklog-backend --tail=20`
- 기대 결과: "Connected to MongoDB" 메시지 확인

### Step 5: Frontend 배포 [AI 프롬프트]
- 명령어: `kubectl apply -f 3.worklog-frontend-manifest.yaml`
- 기대 결과: worklog-frontend Pod Running

### Step 6: 전체 스택 검증 [학습자 직접]
- 명령어: `kubectl get pods`
- 접속: `http://worklog-frontend.myk8s.local`
- 기대 결과: Frontend에서 Backend API 호출 성공, 데이터 저장/조회 가능

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| MongoDB | `kubectl get pods -l app=mongodb` | mongodb Pod Running |
| Backend | `kubectl get pods -l app=worklog-backend` | worklog-backend Pod Running |
| DB 연결 | `kubectl logs -l app=worklog-backend` | "Connected to MongoDB" 로그 |
| Frontend | `kubectl get pods -l app=worklog-frontend` | worklog-frontend Pod Running |
| Ingress | `kubectl get ingress` | backend, frontend Ingress 존재 |
| 통합 테스트 | 브라우저에서 worklog-frontend.myk8s.local 접속 | 화면 정상 표시, 데이터 CRUD 동작 |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| `<dockerhub_username>` | Docker Hub 사용자명 | ❌ 반드시 확인 필요 |

## 주의사항 (Cautions)
- ⛔ `<dockerhub_username>`을 임의로 채우지 말 것 — 수강생의 실제 Docker Hub 계정 사용
- ⛔ MongoDB Secret의 비밀번호는 학습용 — 실무에서는 강력한 비밀번호 사용 필요
- ✅ Backend는 MONGODB_URI Secret을 통해 MongoDB에 연결
- ✅ Frontend는 Ingress를 통해 외부 접속 가능
