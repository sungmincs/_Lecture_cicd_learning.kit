# 3.3 영상 스크립트 — Worklog 앱 Docker 이미지 빌드 및 Push

> 강사가 영상에서 말할 내용 초안. 실제 촬영 시 강사 어조에 맞게 다듬어 사용.
> 시간 가이드는 대략적인 페이싱 기준이며, 실제 시연 속도에 따라 달라질 수 있다.

## 인트로 (~40초)

지난 시간에 Worklog 앱(mock 버전)을 받아서 npm으로 띄워봤죠. 화면은 잘 보였지만 한 가지 한계가 있었습니다. Node.js를 직접 설치해야 했고, 다른 사람과 같은 환경을 공유하려면 매번 같은 셋업을 반복해야 합니다. "내 환경에서는 되는데" 문제가 여기서 나옵니다.

이번 시간에는 같은 앱을 Docker 이미지로 만들고, Docker Hub에 올려서 누구나 받아 쓸 수 있게 만들어보겠습니다.

## 본 챕터

### 사전 준비 — Docker Hub 가입 + backend fork (~2분)

먼저 Docker Hub 계정이 필요합니다. https://hub.docker.com 가서 가입해주세요. 가입 후 username을 기억해두세요 — 이미지 이름에 들어갑니다.

그리고 이번 시간엔 mock뿐 아니라 backend도 함께 빌드합니다. https://github.com/sungmincs/worklog-backend 에 가서 본인 계정으로 fork도 해주세요.

### control plane 노드에서 backend clone (~1분)

control plane 노드로 root 사용자로 들어가서 backend도 clone합니다.

```
ssh root@192.168.1.10
cd /root/workspace
git clone https://github.com/<여러분의-username>/worklog-backend.git
```

이제 workspace 안에 frontend-mock과 backend 두 개가 나란히 있을 거예요.

### Frontend(mock) 이미지 빌드 (~4분)

```
cd /root/workspace/worklog-frontend-mock
docker build . -t <Docker Hub username>/worklog-frontend-mock:buildtest1
```

처음 빌드는 3분 정도 걸립니다. Node.js 24 베이스 이미지를 받고, yarn install이 안에서 실행되거든요. 빌드가 끝나면 `docker images`로 확인해보세요.

여기서 잠깐 살펴볼 만한 게 있어요. Dockerfile을 열어보면, FROM 줄에 `node:24-bookworm-slim`이 있고, COPY로 코드를 넣고, RUN으로 yarn install을 실행합니다. ENTRYPOINT에 `yarn`이 들어가 있어서 컨테이너가 시작하면 yarn dev가 자동으로 돌게 만들어져 있죠. ch3.2에서 우리가 직접 쳤던 명령들이 그대로 Dockerfile 안에 들어 있는 셈입니다.

### Push 시도 — 일부러 실패 (~2분)

이미지가 빌드됐으니 Docker Hub에 올려볼게요.

```
docker push <username>/worklog-frontend-mock:buildtest1
```

여기서 이렇게 나올 거예요.

```
denied: requested access to the resource is denied
```

(Docker 버전에 따라 메시지가 조금 다를 수 있어요. "denied" 또는 "authorization failed" 류가 나옵니다.)

**일부러 이렇게 한 거예요.** Docker Hub는 push 전에 로그인이 필요하다는 걸 직접 체감하시라고요. 한번 에러를 보고 나면, 다음에 다른 레지스트리를 쓸 때도 "아, 인증부터 해야지" 하는 감각이 생깁니다.

### docker login + push 재시도 (~3분)

여기서 한 가지 중요한 거 — **반드시 cp-k8s 안에서, 그러니까 우리가 지금 ssh로 들어와 있는 이 셸 안에서 docker login을 해야 합니다.** 호스트 머신의 Docker Desktop에서 login해도 cp-k8s는 모릅니다. 별개입니다.

```
docker login
```

요즘 Docker(29 버전 이상)는 웹 OAuth로 login해요. 이렇게 나옵니다.

```
USING WEB-BASED LOGIN
Your one-time device confirmation code is: XXXX-YYYY
Press ENTER to open your browser or submit your device code here:
https://login.docker.com/activate
```

호스트 브라우저에서 저 주소로 들어가서 출력된 code를 입력하고, Docker Hub 계정으로 confirm하시면 됩니다. 끝나면 터미널에 `Login Succeeded`가 뜹니다.

CLI에서 username/password로 직접 login하고 싶다면 `docker login -u <username>` 형태로 명시할 수 있어요. 2단계 인증을 쓰고 있다면 비밀번호 대신 Personal Access Token이 필요합니다. Docker Hub 웹에서 Account Settings → Security → New Access Token으로 만들 수 있어요.

로그인이 끝나면 한 번 확인해볼게요.

```
cat /root/.docker/config.json
```

`auths`에 `https://index.docker.io/v1/` 항목이 보이면 OK. 빈 `{}`면 login이 실제로는 안 된 거예요.

이제 다시 push.

```
docker push <username>/worklog-frontend-mock:buildtest1
```

이번엔 layer들이 차례로 올라가면서 마지막에 digest가 출력될 거예요. 성공입니다.

### Backend 이미지 빌드 + push (~3분)

backend도 같은 방식으로 합니다.

```
cd /root/workspace/worklog-backend
docker build . -t <username>/worklog-backend:buildtest1
docker push <username>/worklog-backend:buildtest1
```

backend는 Python에 Poetry를 쓰는 멀티스테이지 빌드라 frontend보다 좀 더 빨라요. 이미 docker login도 끝나 있어서 push도 바로 됩니다.

### Docker Hub 웹에서 확인 (~1분)

https://hub.docker.com 에 들어가서 본인 계정 → Your Repositories를 보면 두 저장소가 만들어져 있고, 각각 `buildtest1` 태그가 보일 거예요. 이게 곧 ch3.4에서 K8s가 받아서 배포할 이미지입니다.

## 학습 포인트 강조

- **컨테이너는 앱 + 실행 환경을 하나로 묶은 거예요.** Node.js·Python을 직접 설치하지 않아도 됩니다.
- **Docker Hub는 이미지의 GitHub 같은 거예요.** 누구나 만든 이미지를 올리고 받아갈 수 있어요.
- **push 실패를 직접 본 게 중요합니다.** "인증 안 하면 못 올린다"는 감각은 글로 읽는 것보다 한 번 실패해본 게 훨씬 오래 남아요.

## 다음 시간 예고 (~30초)

다음 시간(ch3.4)에는 이 이미지들을 쿠버네티스에 배포해보겠습니다. mock의 MSW(가짜 응답)는 빠지고, 진짜 backend와 MongoDB가 함께 떠서 fullstack으로 동작하는 모습을 볼 수 있어요.

## 총 분량 가이드

도입(40초) + 본문(약 16분) + 마무리(30초) = **약 17분**.

mock 첫 빌드 시간, login device-code 브라우저 확인 시간 등에 따라 ±3~5분 변동 가능.
