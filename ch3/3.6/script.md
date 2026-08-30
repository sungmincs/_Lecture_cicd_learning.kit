# 3.4 영상 스크립트 — Worklog 앱을 쿠버네티스에 배포

> 강사가 영상에서 말할 내용 초안. 실제 촬영 시 강사 어조에 맞게 다듬어 사용.
> 시간 가이드는 대략적인 페이싱 기준이며, 실제 시연 속도에 따라 달라질 수 있다.

## 인트로 (~50초)

지난 두 시간 동안 Worklog 앱을 차근차근 정리해왔죠. 3.2에서는 mock 앱을 npm으로 띄워봤고, 3.3에서는 mock과 backend를 각각 Docker 이미지로 빌드해서 Docker Hub에 올렸습니다. 이제 그 이미지들을 진짜 쿠버네티스 클러스터에 올려서 운영급으로 동작시킬 차례입니다.

오늘 끝나면, 호스트 브라우저에서 `http://worklog-frontend.myk8s.local`로 접속했을 때 진짜 backend와 MongoDB까지 연결된 풀스택 앱이 보이게 됩니다. 그리고 코드를 한 줄 바꿔서 새 버전을 배포하면 다운타임 없이 갈아끼워지는 모습도 직접 확인해볼게요.

## 본 챕터

### control plane 접속 + 매니페스트 살펴보기 (~2분)

control plane으로 들어갑니다. 우리가 ch2에서 만들어둔 클러스터죠.

```
ssh root@192.168.1.10
cd /root/_Lecture_cicd_learning.kit/ch3/3.4
ls worklog_manifests/
```

네 개의 yaml 파일이 보입니다. frontend, backend, mongodb, gateway. 각 파일을 열어보시면 Deployment, Service, HTTPRoute 같은 객체들이 선언되어 있어요. gateway.yaml에는 한 개의 Gateway 객체가 따로 있는데, 이건 frontend/backend가 모두 공유하는 외부 진입점입니다.

### LB의 외부 IP 확인 (~1분)

쿠버네티스 외부에서 앱에 접근하려면 입구가 필요해요. NGINX Gateway Fabric controller는 Gateway 객체마다 default namespace에 LoadBalancer Service를 자동으로 만들고, MetalLB이 그 LB에 IP를 자동 할당해줍니다.

```
kubectl get gateway nginx-gateway -o wide
```

ADDRESS 컬럼에 EXTERNAL-IP가 보일 거예요. 우리 환경에서는 `192.168.1.99`로 고정됩니다. 이 IP를 메모해두세요. 다음 단계에서 호스트의 hosts 파일에 등록할 겁니다.

> 💡 vagrant up 직후엔 약 9~10분간 `<pending>`이 정상입니다. extra_k8s_pkgs.sh가 백그라운드 sleep으로 IPAddressPool을 적용하기 때문에 시간이 좀 걸려요. 충분히 기다린 후에도 `<pending>`이면 트러블슈팅 안내를 따라가시면 됩니다.

### 호스트 hosts 파일 수정 (~2분)

지금부터는 잠깐 호스트 머신으로 돌아갑니다. control plane 안이 아니에요.

호스트의 hosts 파일에 두 도메인을 등록합니다. macOS면 `/etc/hosts`, Windows면 `C:\Windows\System32\drivers\etc\hosts`. 둘 다 관리자 권한이 필요해요.

```
<EXTERNAL-IP>  worklog-frontend.myk8s.local
<EXTERNAL-IP>  worklog-backend.myk8s.local
```

이렇게 두 줄 추가하시면 됩니다. 두 호스트 모두 같은 IP에 매핑된다는 게 핵심이에요. 같은 Gateway가 두 호스트를 라우팅으로 분기시키거든요.

### 매니페스트 image 필드 수정 (~2분) `[AI 프롬프트]`

다시 control plane으로. 매니페스트 안의 image 필드가 `<dockerhub_username>` placeholder로 되어 있어요. 본인 Docker Hub username으로 바꿔달라고 AI에 요청합니다.

**진행 멘트:** "sed 명령 문법이 목표가 아니에요. AI에게 요청하면 바로 해줍니다."

> 수강생 입력 예시: "내 Docker Hub username은 sysnet4admin이야. manifests에 반영해줘."

`grep image: *.yaml`로 확인해보시고, 본인 이미지로 잘 들어갔는지 체크.

### 배포 (~2분)

이제 진짜 배포입니다.

```
kubectl apply -f ./worklog_manifests
```

여러 리소스가 한꺼번에 생성됩니다. Gateway, HTTPRoute 두 개, Secret, PVC, Service 세 개, Deployment 세 개. `kubectl get pods,svc,gateway,httproute`로 상태를 보세요.

1-2분 정도 기다리면 세 Pod 모두 Running이 됩니다. mongodb가 가장 늦게 Ready되는 경향이 있어요. NFS PVC를 mount하느라 시간이 좀 걸립니다. backend는 mongodb가 Ready되어야 자기 `/health`를 통과시키니까, mongodb를 기다리는 것처럼 보일 수 있습니다.

Gateway 상태도 확인해보세요.

```
kubectl get gateway nginx-gateway
```

`PROGRAMMED=True`이고 ADDRESS에 우리 LB IP가 표시돼야 정상입니다.

### 브라우저에서 확인 (~2분)

호스트 브라우저로 접속해봅니다.

```
http://worklog-frontend.myk8s.local
http://worklog-backend.myk8s.local
```

frontend는 ch3.2에서 봤던 화면과 같이 보일 거예요. **그런데 한 가지 다릅니다.** 지금은 MSW가 가짜 응답을 주는 게 아니라, **진짜 backend Pod이 mongodb Pod과 통신해서 응답**합니다. UI에서 작업 기록을 하나 추가해보세요. 새로고침해도 그대로 남아있죠? 이게 mongodb에 진짜 저장된 거예요. NFS PV에 영구 저장됐고, Pod이 재시작돼도 살아남습니다.

backend 쪽은 Swagger UI가 뜨거나 JSON 응답이 보일 거예요. API를 직접 호출해보는 것도 가능합니다.

### 코드 수정 → 재배포 워크플로우 (~5분)

운영에서 가장 자주 일어나는 흐름이에요. 코드를 한 줄 바꾸고, 새 이미지 만들고, 클러스터에 갈아끼우는 거.

```
cd /root/workspace/worklog-frontend-mock
grep -rn "Summary" src/
```

`Summary`라는 텍스트가 있는 파일을 찾고, "Summary"를 "Dates"로 바꿔달라고 AI에 요청합니다. `[AI 프롬프트]`

> 수강생 입력 예시: "worklog-frontend-mock 소스에서 Summary를 Dates로 바꿔줘."

빌드와 push는 수강생이 직접 합니다. `[학습자 직접]`

```
docker build . -t <username>/worklog-frontend-mock:buildtest2
docker push <username>/worklog-frontend-mock:buildtest2
```

build와 push는 ch3.3에서 한 거랑 똑같죠. 이번엔 태그를 `buildtest2`로.

이제 클러스터에 갈아끼웁니다. `vi` 설명이 목표가 아니니 AI에 요청합니다. `[AI 프롬프트]`

> 수강생 입력 예시: "worklog-frontend를 buildtest2 이미지로 업데이트해줘."

`kubectl get pods -w`를 띄워놓고 보세요. 새 Pod이 만들어지고, 새 Pod이 Ready가 되면 그제서야 옛 Pod이 Terminating됩니다. 이게 RollingUpdate예요. **다운타임 거의 없이 갈아끼워지는 거**죠.

호스트 브라우저에서 새로고침하면 "Summary"가 "Dates"로 바뀌어있을 거예요.

### Cleanup (~1분)

오늘 시연이 끝났으면 정리.

```
kubectl delete -f /root/_Lecture_cicd_learning.kit/ch3/3.4/worklog_manifests
```

배포한 모든 리소스가 삭제됩니다. ch4에서 다시 쓸 수도 있으니 hosts 파일은 그대로 둬도 됩니다.

## 학습 포인트 강조

- **mock에서 진짜로 진화한 흐름** — ch3.2 mock(브라우저 가짜 응답) → ch3.3 컨테이너화 → ch3.4 K8s에서 진짜 풀스택. 각 단계마다 한 가지씩 늘어났어요.
- **K8s 객체들 한 번에 등장** — Deployment, Service, **Gateway, HTTPRoute**, PVC, Secret. ch5 이후에도 계속 등장할 핵심들이에요.
- **Gateway API가 모던 표준** — Ingress의 후속이에요. Gateway(인프라)와 HTTPRoute(앱)가 분리되어 있어서 한 개의 Gateway를 여러 HTTPRoute가 공유할 수 있죠.
- **kubectl edit으로 image 갈아끼운 게 핵심** — 다운타임 거의 없이 새 버전 배포. **이걸 자동화하는 게 ch4 이후의 CI/CD입니다.**
- **운영급의 첫 모습** — 한 컴퓨터에서 docker run하는 거랑은 차원이 다른, 멀티 노드 + 자동 복구 + 영구 저장이 합쳐진 환경이에요.

## 다음 시간 예고 (~30초)

오늘은 kubectl edit으로 직접 갈아끼웠지만, 운영에서는 코드만 git push하면 자동으로 빌드되고 자동으로 배포되어야 합니다. 다음 챕터(ch4)부터 GitHub Actions, Jenkins, GitLab CI 세 도구로 같은 흐름을 자동화해볼게요. 오늘 한 작업을 어떻게 손 안 대고 돌릴 수 있는지 직접 만들어봅시다.

## 총 분량 가이드

도입(50초) + 본문(약 17분) + 마무리(30초) = **약 19분**.

build/push 시간, RollingUpdate 대기, 트러블슈팅 등에 따라 ±5분 변동 가능.
