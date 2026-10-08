# 파이프라인은 한 번에 하나만 켠다

ch5부터 ch9까지 GitHub Actions 워크플로와 Jenkins 파이프라인을 번갈아 만든다. 앞에서 만든 것을 켜 둔 채 다음 절로 가면
push 한 번에 여러 파이프라인이 함께 돈다. 같은 이미지를 두세 번 빌드하고, 둘 이상이 `deploy_manifest/`를 고치면
늦게 끝난 쪽이 매니페스트를 옛 태그로 되돌린다(run-38 6.7과 6.8, 7.8과 7.9, 8.3과 8.4에서 실제로 일어났다).

그래서 각 절의 **단계 0**에서 이 규칙을 적용한다.

## 규칙

- 한 저장소에서 main에 push로 도는 파이프라인은 **지금 실습하는 절의 것 하나만** 켠다.
- GitHub 절에서 새 워크플로 파일을 만들면, 그 전에 켜져 있던 워크플로를 모두 끈다.
- GitHub 절에서 앞 절의 파일을 고치면(5.4, 6.7, 8.4, 9.4~9.6), 그 파일 하나만 켜 둔다. 꺼져 있으면 켠다.
- Jenkins 절에서는 그 저장소의 GitHub 워크플로를 모두 끈다. Jenkinsfile을 push하면 GitHub 워크플로도 같은 push로 돈다.
- Jenkins는 따로 끄지 않는다. 이 강의의 Multibranch job은 'Scan Multibranch Pipeline Now'를 누를 때만 빌드한다(웹훅과 주기 스캔을 쓰지 않는다).
  GitHub 절을 실습하는 동안 스캔을 누르지 않으면 된다.
- Jenkins 절을 마쳐도 GitHub 워크플로를 다시 켜지 않는다. 다음 GitHub 절의 단계 0이 무엇을 켤지 정한다.

## 끄고 켜는 방법

GitHub 저장소 → **Actions** → 왼쪽 목록에서 워크플로 이름 → 오른쪽 위 **⋯** → **Disable workflow**(켤 때는 같은 자리의 **Enable workflow**).

`gh` CLI가 있으면 명령으로도 된다.

```bash
gh workflow list --all -R <github_username>/worklog-backend      # 이름과 상태(active, disabled_manually)
gh workflow disable <워크플로 파일 이름> -R <github_username>/worklog-backend
gh workflow enable  <워크플로 파일 이름> -R <github_username>/worklog-backend
```

- 파일을 지우는 대신 끄는 이유: 앞 절 결과를 다시 볼 수 있고, 6.7처럼 같은 파일을 다시 고치는 절이 있다.
- 꺼 둔 워크플로는 push해도 실행되지 않는다. 다시 켜야 할 절에서 "왜 안 돌지?"가 나오면 Actions 탭에서 상태부터 본다(8.3 주의사항).

## 절별 정리

| 절 | 도구 | 단계 0에서 할 일 |
|---|---|---|
| 5.3 | GitHub | ch4 워크플로(4.3 hello 두 개, 4.4 빌드 파이프라인)를 끈다. 4.4는 실패 예시로 끝나 있어 켜 두면 push마다 실패가 쌓인다 |
| 5.4 | GitHub | 5.3 파일을 고친다. 그대로 |
| 5.5, 5.6 | Jenkins | 5.3/5.4 워크플로를 끈다 |
| 6.7 | GitHub | 5.3/5.4 워크플로를 다시 켠다(이 절에서 그 파일을 고친다) |
| 6.8 | Jenkins | 6.7 워크플로를 끈다 |
| 7.8 | GitHub | backend의 6.7 워크플로가 꺼져 있는지 본다. frontend는 처음 만든다 |
| 7.9 | Jenkins | 두 저장소의 7.8 워크플로를 끈다 |
| 8.3 | GitHub | backend의 7.8 워크플로가 꺼져 있는지 본다 |
| 8.4 | GitHub | 8.3 파일을 고친다. 그대로 |
| 8.5, 8.6 | Jenkins | 8.3/8.4 워크플로를 끈다 |
| 9.3~9.5 | 둘 다 | ch8 워크플로가 꺼져 있는지 본다. 이 구간의 GitHub `ci.yaml`은 게이트만 있고 배포가 없어 Jenkins와 충돌하지 않는다. 껐다 켤 필요 없다 |
| 9.6~9.8 | 둘 다 | 9.6부터 `ci.yaml`에 deploy가 붙는다. Jenkins로 실습하는 동안은 `ci.yaml`을 끄고, GitHub로 실습하는 동안은 Jenkins 스캔을 누르지 않는다 |
| 10.6 | GitHub | ch9 `ci.yaml`을 끈다. EKS용 워크플로가 같은 저장소 main에서 돈다 |
| 10.7 | Jenkins | 10.6 워크플로를 끈다 |
| 10.9 | GitLab | GitLab은 다른 저장소(import)라 GitHub 쪽과 겹치지 않는다. 다만 Argo CD가 보는 저장소를 바꾸는 단계가 있으니 그 절을 따른다 |
