# GUARDRAIL: 6.5 Argo CD 배포 알림 설정하기 (Slack)

## 범위 (Scope)
### 이 단계에서 다루는 것
- Slack 웹훅 URL 설정
- Argo CD notification secret 생성
- Application에 알림 annotation 추가
- 배포/동기화 실패/헬스 저하 시 Slack 알림 수신 확인

### 이 단계에서 다루지 않는 것
- Slack 앱 생성 절차 상세 (수강생이 직접 진행)
- CI 파이프라인 통합 (6.6~6.8에서 다룸)

## 사전 조건 (Prerequisites)
- ch6/6.4 완료 (Argo CD Application 생성 및 배포 성공)
- Slack 워크스페이스 접근 권한 (웹훅 URL 생성 가능)

## 순서 (Sequence)
### Step 1: Slack App 생성 및 웹훅 URL 획득 [학습자 직접]
- URL: https://api.slack.com/apps
- 기대 결과: Incoming Webhook URL 획득 (xoxb-... 또는 https://hooks.slack.com/...)

### Step 2: Argo CD notification secret 생성 [학습자 직접]
- 명령어: `kubectl create secret generic argocd-notifications-secret -n argocd --from-literal=slack-token=<slack_webhook_url> --dry-run=client -o yaml | kubectl apply -f -`
- 기대 결과: argocd-notifications-secret 시크릿 생성/업데이트

### Step 3: Application에 알림 annotation 추가 [학습자 직접]
- 명령어: `kubectl patch app worklog-backend -n argocd -p '{"metadata": {"annotations": {"notifications.argoproj.io/subscribe.on-deployed.slack":"dev_bots", ...}}}' --type merge`
- 기대 결과: annotation 3개 추가 (on-deployed, on-health-degraded, on-sync-failed)

### Step 4: 알림 테스트 [학습자 직접]
- 코드 변경 후 push하여 동기화 트리거
- 기대 결과: Slack dev_bots 채널에 배포 알림 수신

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| secret | `kubectl get secret argocd-notifications-secret -n argocd` | secret 존재 |
| annotation | `kubectl get app worklog-backend -n argocd -o yaml` | notifications annotation 3개 존재 |
| 알림 수신 | Slack dev_bots 채널 확인 | 배포 완료 메시지 수신 |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| `<slack_webhook_url>` | Slack Incoming Webhook URL | ❌ 반드시 수강생에게 확인 필요 |

## 주의사항 (Cautions)
- ⛔ Slack 앱 생성은 수강생이 직접 진행 — AI는 URL 안내만 제공
- ⛔ `<slack_webhook_url>`을 임의로 채우지 말 것
- ⛔ Slack 토큰/웹훅 URL을 Git에 커밋하지 말 것
- ✅ dev_bots 채널이 Slack 워크스페이스에 미리 생성되어 있어야 함
- ✅ notification catalog는 6.2에서 이미 적용됨 (argocd-notification-catalog.yaml)
