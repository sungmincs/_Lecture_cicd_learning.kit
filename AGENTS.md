# AGENTS.md

이 저장소의 AI 에이전트 규칙은 `CLAUDE.md` 한 곳에 있습니다. 이 파일은 `CLAUDE.md`를 가리키는 입구입니다.

## 먼저 할 일

작업을 시작하기 전에 저장소 루트의 [`CLAUDE.md`](CLAUDE.md)를 읽고, 그 내용을 이 파일에 그대로 적힌 지시로 간주해 따릅니다. 가드레일 모드, 학습자 입력과 참조 파일 매칭, kubectl 안전 규칙, 실행 규칙이 모두 거기에 있습니다.

Claude Code는 `CLAUDE.md`를, Codex를 비롯한 다른 도구는 이 `AGENTS.md`를 읽습니다. 읽는 파일은 달라도 따르는 규칙은 하나입니다.

## 실행 명령

이 강의는 승인 없이 명령이 실행되는 모드를 기준으로 합니다.

| Claude Code | Codex CLI |
|---|---|
| `claude --dangerously-skip-permissions` | `codex --full-auto --sandbox danger-full-access` |

Codex의 기본 sandbox(`workspace-write`)는 외부 네트워크를 막습니다. 이 강의는 실습용 쿠버네티스 클러스터와 컨테이너 레지스트리에 접근하므로 네트워크 허용이 필요합니다.

## 규칙을 고칠 때

`CLAUDE.md`만 고칩니다. 이 파일에는 규칙을 옮겨 적지 않습니다. 두 곳에 나뉘면 어느 쪽이 최신인지 알 수 없게 됩니다.

## 최소한 이것만은

`CLAUDE.md`를 읽지 못한 경우에도 아래는 지킵니다. 어겼을 때 되돌리기가 가장 번거로운 항목들입니다.

- 한국어로 진행합니다. 대화가 요약(compaction)되더라도 한국어를 유지합니다.
- 비밀값을 커밋하지 않습니다. Docker Hub 토큰, GitLab 액세스 토큰, AWS 액세스 키가 이 강의에 모두 나옵니다. 커밋하면 push할 때 그대로 올라가고 이력에 남아 지워도 되돌릴 수 없습니다. Secret은 클러스터에 직접 만들고 매니페스트는 참조만 합니다.
- kubectl의 대상 클러스터를 확인합니다. 승인 없이 명령이 실행되므로, 10장에서 EKS를 추가한 뒤에는 `kubectl config use-context` 또는 `--context`로 대상을 명시합니다.
- AWS 리소스는 요청받은 것만 만듭니다. 10장의 EKS는 켜 둔 시간만큼 과금되므로 실습을 마치면 `terraform destroy`로 지웠는지 확인합니다.

나머지 규칙과 배경은 `CLAUDE.md`에서 확인합니다.
