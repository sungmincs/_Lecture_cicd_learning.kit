# GUARDRAIL: 2.11 Docker를 모든 노드에 설치

## 범위 (Scope)
### 이 단계에서 다루는 것
- K8s 클러스터의 **모든 노드**(control plane + 워커 3대)에 Docker 설치
- control plane은 로컬 실행, 워커는 sshpass로 원격 설치

### 이 단계에서 다루지 않는 것
- Docker 이미지 빌드 (ch3/3.3에서 다룸)
- Docker 기본 사용법 (ch3/3.2에서 다룸 — Docker 없이 npm으로 실행)

## 사전 조건 (Prerequisites)
- ch2/2.3 또는 ch2/2.4 완료 (K8s 클러스터 구축 완료)
- control plane 노드에 root로 SSH 접속 가능 (`controlplane_node.sh` 안에서 `/root/_Lecture_cicd_learning.kit`이 자동 clone됨)
- control plane → worker 노드 SSH 접속 가능 (vagrant box 기본 설정)

## 순서 (Sequence)

### Step 1: control plane 노드에 root로 접속

```bash
ssh root@192.168.1.10
# 비밀번호: vagrant
```

### Step 2: 본 디렉터리로 이동

```bash
cd /root/_Lecture_cicd_learning.kit/ch2/2.11
```

### Step 3: 설치 스크립트 실행

```bash
bash docker_all_nodes_installer.sh
```

동작:
- control plane(local)에 Docker 설치
- sshpass로 워커 노드 3대(192.168.1.101~103)에 Docker 설치

기대 결과: 4개 노드 모두에 Docker 설치 완료

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| Docker 설치 | 각 노드(cp + w1~w3)에서 `docker version` | Docker 버전 정보 출력 |
| Docker 동작 | 각 노드에서 `docker ps` | 권한 오류 없이 실행 |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| (없음) | - | - |

## 주의사항 (Cautions)
- ⛔ 반드시 control plane 노드(`cp-k8s`)에 root로 접속 후 실행
- ⛔ `./install_docker.sh` 파일이 같은 디렉토리(ch2/2.11)에 존재해야 함
- ✅ 스크립트가 cp(local) + 워커 노드 3대(w1~w3) 총 4개 노드를 대상으로 순차 실행
- ✅ root 사용자라 별도 sudo·chmod 666 docker.sock 불필요

## 변경 이력
- 2026-05-08: cp 포함하도록 확장. install_docker.sh를 ch3/3.2/에서 이동.
- 2026-05-11: root 표준으로 재정비 — sudo·chmod 666 제거. ssh root@ 접속 명시.
