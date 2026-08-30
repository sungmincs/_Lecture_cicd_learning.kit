# GUARDRAIL: 2.3 VirtualBox, Vagrant, Tabby 설치 (x86-64/amd64)

## 범위 (Scope)
### 이 단계에서 다루는 것
- VirtualBox 7.0.18 설치 (Windows: winget, Mac: brew)
- Vagrant 2.4.1 설치 (Windows: winget, Mac: brew)
- Tabby 1.0.207 설치 및 설정 파일 복사

### 이 단계에서 다루지 않는 것
- arm64 사용자용 설치 (2.4에서 다룸)
- K8s 클러스터 구성
- Docker 설치
- Vagrant를 이용한 VM 생성/실행

## 사전 조건 (Prerequisites)
- 없음 (첫 번째 실습 단계)

## 순서 (Sequence)

### Step 1: VirtualBox 7.0.18 설치
- **Windows**
  - 명령어: `winget install -e --id Oracle.VirtualBox -v 7.0.18`
  - 참고: https://winget.run/pkg/Oracle/VirtualBox
- **MacOS (x86-64)**
  - 명령어: `brew install --cask ./virtualbox-v7.0.18/virtualbox.rb`
  - 참고: 로컬 .rb 파일을 사용하여 버전을 고정함
- 기대 결과: VirtualBox 7.0.18이 설치됨

### Step 2: Vagrant 2.4.1 설치
- **Windows**
  - 명령어: `winget install -e --id Hashicorp.Vagrant -v 2.4.1`
  - 참고: https://winget.run/pkg/Hashicorp/Vagrant
- **MacOS (x86-64)**
  - 명령어: `brew install --cask ./vagrant-v2.4.1/vagrant.rb`
- 기대 결과: Vagrant 2.4.1이 설치됨

### Step 3: Tabby 1.0.207 설치 및 설정 파일 복사
- **Windows**
  - 설치: `winget install -e --id Eugeny.Tabby -v 1.0.207`
  - 설정 복사: `cp ./tabby-v1.0.207/config.yaml $env:APPDATA/tabby/`
- **MacOS**
  - 설치: `brew install --cask ./tabby-v1.0.207/tabby.rb`
  - 설정 복사: `cp ./tabby-v1.0.207/config.yaml ~/Library/Application\ Support/tabby/`
- 기대 결과: Tabby가 설치되고 사전 구성된 config.yaml이 적용됨

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| VirtualBox | `virtualbox --help` 또는 VirtualBox 앱 실행 | 버전 7.0.18 확인 |
| Vagrant | `vagrant --version` | `Vagrant 2.4.1` 출력 |
| Tabby | Tabby 앱 실행 | 정상 실행 및 config.yaml 설정 반영 확인 |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| (없음) | | |

## 주의사항 (Cautions)
- ⛔ AI가 하지 말아야 할 것: 버전을 임의로 변경하지 말 것 (VirtualBox 7.0.18, Vagrant 2.4.1, Tabby 1.0.207 정확히 준수)
- ⛔ AI가 하지 말아야 할 것: arm64 사용자에게 이 가이드를 적용하지 말 것 (arm64는 2.4 참조)
- ⛔ AI가 하지 말아야 할 것: `brew install --cask virtualbox` 처럼 최신 버전으로 설치하는 명령 안내 금지 — 반드시 로컬 .rb 파일을 사용
- ✅ AI가 해도 되는 것: OS 감지 후 해당 OS에 맞는 명령어만 안내
- ✅ AI가 해도 되는 것: 설치 오류 발생 시 트러블슈팅 안내
