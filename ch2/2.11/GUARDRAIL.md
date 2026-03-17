# GUARDRAIL: 2.11 Docker를 모든 노드에 설치

## 범위 (Scope)
### 이 단계에서 다루는 것
- K8s 클러스터의 모든 워커 노드에 Docker 설치
- sshpass를 이용한 원격 설치 자동화

### 이 단계에서 다루지 않는 것
- Docker 이미지 빌드 (ch3/3.3에서 다룸)
- Docker 기본 사용법 (ch3/3.2에서 다룸)

## 사전 조건 (Prerequisites)
- ch2/2.3 또는 ch2/2.4 완료 (K8s 클러스터 구축 완료)
- control plane 노드에서 워커 노드로 SSH 접속 가능

## 순서 (Sequence)
### Step 1: 설치 스크립트 실행
- 명령어: `bash docker_all_nodes_installer.sh`
- 동작: sshpass로 워커 노드 3대(192.168.1.101~103)에 Docker 설치
- 기대 결과: 모든 노드에 Docker 설치 완료

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| Docker 설치 | 각 워커 노드에서 `docker version` | Docker 버전 정보 출력 |
| Docker 소켓 | 각 워커 노드에서 `docker ps` | 권한 오류 없이 실행 |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| (없음) | - | - |

## 주의사항 (Cautions)
- ⛔ 반드시 control plane 노드(m-k8s)에서 실행
- ⛔ ch3/3.2/install_docker.sh 파일이 존재해야 함 (상대 경로 참조)
- ✅ 스크립트가 워커 노드 3대(w1~w3)를 대상으로 순차 실행
