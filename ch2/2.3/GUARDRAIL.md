# GUARDRAIL: 2.3 VirtualBox, Vagrant, Tabby 설치 (x86-64/amd64)

## 범위 (Scope)
### 이 단계에서 다루는 것
- VirtualBox 7.0.18 설치 (Windows: winget, Mac: brew)
- Vagrant 2.4.1 설치 (Windows: winget, Mac: brew)
- Tabby 1.0.207 설치 및 설정 파일 복사
- `vagrant up`으로 K8s 클러스터 자동 구성
- 클러스터 구성 결과 검증 (NGINX Gateway Fabric, MetalLB, 노드 상태)

### 자동 설치되는 구성 요소 (vagrant up 시)
- Kubernetes 1.35.2 (control-plane 1 + worker 3)
- MetalLB v0.15.3 (LoadBalancer)
- **NGINX Gateway Fabric v2.3.0** (HTTP 라우팅 — LB IP: `192.168.1.99`)
  - ⚠️ ingress-nginx가 아님. 이 강의 전체에서 `HTTPRoute`를 사용
- Helm v4.0.4
- metrics-server v0.8.0
- NFS StorageClass (기본 StorageClass로 설정)

### 이 단계에서 다루지 않는 것
- arm64 사용자용 설치 (2.4에서 다룸)
- Docker 설치 (2.11에서 다룸)

## 사전 조건 (Prerequisites)
- 없음 (첫 번째 실습 단계)

## 순서 (Sequence)

### Step 1: VirtualBox 7.0.18 설치 [학습자 직접]
- **Windows**
  - 명령어: `winget install -e --id Oracle.VirtualBox -v 7.0.18`
  - 참고: https://winget.run/pkg/Oracle/VirtualBox
- **MacOS (x86-64)**
  - 명령어: `brew install --cask ./virtualbox-v7.0.18/virtualbox.rb`
  - 참고: 로컬 .rb 파일을 사용하여 버전을 고정함
- 기대 결과: VirtualBox 7.0.18이 설치됨

### Step 2: Vagrant 2.4.1 설치 [학습자 직접]
- **Windows**
  - 명령어: `winget install -e --id Hashicorp.Vagrant -v 2.4.1`
  - 참고: https://winget.run/pkg/Hashicorp/Vagrant
- **MacOS (x86-64)**
  - 명령어: `brew install --cask ./vagrant-v2.4.1/vagrant.rb`
- 기대 결과: Vagrant 2.4.1이 설치됨

### Step 3: Tabby 1.0.207 설치 및 설정 파일 복사 [학습자 직접]
- **Windows**
  - 설치: `winget install -e --id Eugeny.Tabby -v 1.0.207`
  - 설정 복사: `cp ./tabby-v1.0.207/config.yaml $env:APPDATA/tabby/`
- **MacOS**
  - 설치: `brew install --cask ./tabby-v1.0.207/tabby.rb`
  - 설정 복사: `cp ./tabby-v1.0.207/config.yaml ~/Library/Application\ Support/tabby/`
- 기대 결과: Tabby가 설치되고 사전 구성된 config.yaml이 적용됨

### Step 4: K8s 클러스터 구성 (vagrant up) [학습자 직접]

```bash
cd ~/_Lecture_cicd_learning.kit/ch2/2.3
vagrant up
```

프로비저닝 완료까지 약 15~20분 소요

### Step 5: 클러스터 검증 [학습자 직접]

```bash
sshpass -p "vagrant" ssh root@192.168.1.10

kubectl get nodes
kubectl get pods -A | grep -E "nginx-gateway|metallb"
kubectl get svc -A | grep LoadBalancer
kubectl get gateway -A
```

> "지금 설치된 NGINX Gateway Fabric이 기존 ingress-nginx와 어떻게 다른지 설명해줘"

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| VirtualBox | `virtualbox --help` 또는 VirtualBox 앱 실행 | 버전 7.0.18 확인 |
| Vagrant | `vagrant --version` | `Vagrant 2.4.1` 출력 |
| Tabby | Tabby 앱 실행 | 정상 실행 및 config.yaml 설정 반영 확인 |
| K8s 노드 | `kubectl get nodes` | 4개 노드 Ready (cp-k8s + w1~w3) |
| NGINX GW | `kubectl get pods -A \| grep nginx-gateway` | nginx-gateway Pod Running |
| MetalLB | `kubectl get pods -A \| grep metallb` | controller + speaker Pod Running |
| LB IP | `kubectl get svc -A \| grep LoadBalancer` | nginx-gateway-nginx: 192.168.1.99 |
| Gateway | `kubectl get gateway -A` | nginx-gateway Accepted |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| (없음) | | |

## 주의사항 (Cautions)
- ⛔ AI가 하지 말아야 할 것: 버전을 임의로 변경하지 말 것 (VirtualBox 7.0.18, Vagrant 2.4.1, Tabby 1.0.207 정확히 준수)
- ⛔ AI가 하지 말아야 할 것: arm64 사용자에게 이 가이드를 적용하지 말 것 (arm64는 2.4 참조)
- ⛔ AI가 하지 말아야 할 것: `brew install --cask virtualbox` 처럼 최신 버전으로 설치하는 명령 안내 금지 — 반드시 로컬 .rb 파일을 사용
- ⛔ 이 클러스터는 **ingress-nginx가 아닌 NGINX Gateway Fabric**을 사용 — `kubectl apply -f ingress.yaml` 안내 금지. HTTPRoute 사용
- ✅ AI가 해도 되는 것: OS 감지 후 해당 OS에 맞는 명령어만 안내
- ✅ AI가 해도 되는 것: 설치 오류 발생 시 트러블슈팅 안내
- ✅ vagrant up 소요 시간: 15~20분 (MetalLB IP 할당 완료까지 sleep 600s 대기 포함)
