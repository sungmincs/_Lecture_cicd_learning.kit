# GUARDRAIL: 6.3 Argo CD UI 탐색 및 CLI 설치

## 범위 (Scope)
### 이 단계에서 다루는 것
- Argo CD UI 접속 및 초기 로그인
- Argo CD CLI 설치
- CLI를 통한 기본 명령어 탐색 (로그인, 계정 목록 확인)

### 이 단계에서 다루지 않는 것
- Argo CD Application 생성 및 서비스 배포 (6.4에서 다룸)
- 알림 설정 (6.5에서 다룸)

## 사전 조건 (Prerequisites)
- ch6/6.2 완료 (Argo CD 설치 완료, 모든 pod Running)

## 순서 (Sequence)
### Step 1: 초기 admin 비밀번호 확인 [학습자 직접]
- 명령어: `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`
- 기대 결과: 초기 비밀번호 문자열 출력

### Step 2: hosts 파일 업데이트 [AI 프롬프트]
- 명령어: hosts 파일에 `192.168.1.99 argocd.myk8s.local` 추가
- 기대 결과: argocd.myk8s.local 도메인 해석 가능

### Step 3: Argo CD UI 접속 [학습자 직접]
- URL: `https://argocd.myk8s.local`
- 기대 결과: 로그인 페이지 표시, admin/<initial_password>로 로그인 성공

### Step 4: Argo CD CLI 설치 [학습자 직접]
- 명령어: curl로 바이너리 다운로드 후 /usr/local/bin에 설치
- 기대 결과: `argocd version` 명령어 정상 동작

### Step 5: CLI로 로그인 [학습자 직접]
- 명령어: `argocd login argocd.myk8s.local --username admin --password <initial_password> --insecure`
- 기대 결과: 로그인 성공 메시지

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| UI 접속 | 브라우저에서 https://argocd.myk8s.local 접속 | 대시보드 표시 |
| CLI 설치 | `argocd version` | 버전 정보 출력 |
| CLI 로그인 | `argocd account list` | admin 계정 목록 표시 |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| `<initial_password>` | Argo CD 초기 admin 비밀번호 (자동 생성됨) | ❌ kubectl 명령으로 직접 확인 필요 |

## 주의사항 (Cautions)
- ⛔ 초기 비밀번호는 설치마다 다르므로 직접 확인 필수
- ⛔ --insecure 플래그는 학습 환경에서만 사용 (self-signed cert)
- ✅ hosts 파일 수정 후 브라우저 캐시 확인
- ✅ CLI 설치는 control plane 노드에서 수행
