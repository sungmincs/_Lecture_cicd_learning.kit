# 3.2 영상 스크립트 — Worklog 앱 다운로드 및 로컬 실행

> 강사가 영상에서 말할 내용 초안. 실제 촬영 시 강사 어조에 맞게 다듬어 사용.
> 시간 가이드는 대략적인 페이싱 기준이며, 실제 시연 속도에 따라 달라질 수 있다.

## 인트로 (~30초)

지난 시간에 Vagrant로 쿠버네티스 클러스터를 만들었죠. 이번 시간부터는 이 클러스터에서 운영할 앱이 필요합니다.

오늘은 가장 가볍게, Docker도 쓰지 않고 백엔드도 띄우지 않고 Worklog 앱을 받아서 실행만 해보겠습니다. 다음 시간에 Docker로 컨테이너화하고, 그 다음에 쿠버네티스에 배포하는 식으로 차근차근 가보겠습니다.

## 본 챕터

### control plane 노드로 들어가기 (~1분)

먼저 control plane 노드 안으로 들어갑니다. 호스트 머신이 아니라 Vagrant VM 안에서 작업한다는 점이 중요합니다. ssh로 root 사용자로 접속할게요. 비밀번호는 vagrant입니다.

```
ssh root@192.168.1.10
```

여기서부터 모든 명령은 이 VM 안에서, root 사용자로 실행됩니다.

### Node.js와 Yarn 설치 (~2분)

이 mock 앱은 React + Vite 기반이라 Node.js가 필요합니다. NodeSource 공식 스크립트로 Node.js 24를 설치합니다.

```
curl -fsSL https://deb.nodesource.com/setup_24.x | bash -
apt-get install -y nodejs
npm install -g yarn
```

설치가 끝나면 `node --version`, `yarn --version`으로 확인합니다.

### 앱 받아오기 (~2분)

GitHub에서 `sungmincs/worklog-frontend-mock` 저장소를 본인 계정으로 fork합니다. 그리고 control plane 노드 안에서 fork한 저장소를 clone합니다.

```
mkdir -p /root/workspace
cd /root/workspace
git clone https://github.com/<여러분의-username>/worklog-frontend-mock.git
cd worklog-frontend-mock
```

### 의존성 설치 + dev server 실행 (~3분)

```
yarn install
```

처음에는 1~2분 정도 걸립니다. React, Vite, MUI 같은 패키지를 다운받는 시간입니다.

설치가 끝나면 dev server를 실행합니다.

```
yarn dev --host 0.0.0.0
```

여기서 `--host 0.0.0.0`이 핵심입니다. 이 옵션을 빠뜨리면 호스트 브라우저에서 접속이 안 됩니다. dev server가 VM 내부의 localhost(127.0.0.1)에만 바인딩되기 때문이에요.

### 호스트에서 화면 확인 (~1분)

호스트 머신 브라우저에서 `http://192.168.1.10:5173`로 접속하면 Worklog 앱 화면이 보입니다.

여기서 잠깐, 이 mock 앱은 백엔드가 없습니다. 그런데 화면에는 작업 기록이 표시되죠. **MSW (Mock Service Worker)** 라는 라이브러리가 브라우저에서 fetch 요청을 가로채서 가짜 응답을 만들어주기 때문입니다. 진짜 백엔드는 ch3.4에서 붙여줄 거예요.

## 학습 포인트 강조

- **Docker 없이 npm으로 실행 가능합니다.** 평소 앱을 받아 실행하는 가장 일반적인 방식이에요.
- **다만 한계가 있어요.** Node.js를 직접 설치해야 하고, 환경마다 버전이 다르면 동작이 달라질 수 있어요. "내 환경에서는 되는데"라는 말이 여기서 나오는 거죠.
- **그래서 다음 시간에 Docker가 등장하는 거예요.**

## 다음 시간 예고 (~30초)

다음 시간에는 같은 앱을 Dockerfile로 컨테이너화해서 실행해보겠습니다. "내 환경에서는 되는데" 문제를 컨테이너가 어떻게 해결하는지 직접 체감해볼 수 있습니다.

## 총 분량 가이드

도입(30초) + 본문(약 9분) + 마무리(30초) = **약 10분**.

실제 시연 시 환경 차이(네트워크 속도, npm install 시간 등)로 ±2~3분 변동 가능.
