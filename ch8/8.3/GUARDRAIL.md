# GUARDRAIL: 8.3 PR / Branch / Tag 기반 배포 패턴

## 범위 (Scope)
### 이 단계에서 다루는 것
- PR 기반 배포 패턴: PR 생성/merge 이벤트에 따른 배포 전략
- Branch 기반 배포 패턴: 브랜치별 배포 대상 환경 매핑 (develop → dev, release/* → staging, main → staging)
- Tag 기반 배포 패턴: Git 태그(v*.*.*)를 이용한 프로덕션 릴리스
- 실습을 위한 develop, release/1.0 브랜치 생성

### 이 단계에서 다루지 않는 것
- 파이프라인 구현 (8.4~8.9에서 다룸)
- GitFlow, Trunk-based development 등 브랜치 전략 상세 이론
- SemVer 버전 관리 자동화 도구 (semantic-release 등)

## 사전 조건 (Prerequisites)
- ch3 완료 (worklog-backend 저장소 준비)
- ch8/8.2 완료 (dev/staging/prod namespace 생성)

## 순서 (Sequence)
### Step 1: 배포 패턴 개념 이해
- PR-based: PR 이벤트(opened, synchronize) 발생 시 dev namespace에 preview 배포
- Branch-based: develop 브랜치 push → dev, release/* push → staging
- Tag-based: v*.*.* 태그 생성 시 prod namespace에 배포
- 기대 결과: 각 패턴의 트리거 조건과 대상 환경을 이해

### Step 2: develop 브랜치 생성
- 명령어: `git checkout -b develop && git push origin develop`
- 기대 결과: origin에 develop 브랜치 생성

### Step 3: release/1.0 브랜치 생성
- 명령어: `git checkout -b release/1.0 && git push origin release/1.0`
- 기대 결과: origin에 release/1.0 브랜치 생성

### Step 4: main 브랜치로 복귀
- 명령어: `git checkout main`
- 기대 결과: main 브랜치에서 다음 단계 진행 준비 완료

## 검증 (Validation)
| 단계 | 검증 방법 | 기대 결과 |
|------|----------|----------|
| 브랜치 생성 | `git branch -a` | develop, release/1.0 브랜치가 로컬 및 원격에 존재 |
| 현재 브랜치 | `git branch --show-current` | main |

## 플레이스홀더 (Placeholders)
| 플레이스홀더 | 설명 | AI가 임의로 채워도 되는가? |
|-------------|------|------------------------|
| 없음 | - | - |

## 주의사항 (Cautions)
- ⛔ 이미 동일한 이름의 브랜치가 존재하면 `git checkout -b`가 실패한다. 이 경우 `git checkout develop`으로 전환한다.
- ✅ 브랜치 이름 규칙(develop, release/*)은 이후 파이프라인에서 환경 판별 조건으로 사용되므로 정확히 일치해야 한다.
- ✅ Tag 기반 배포는 8.4~8.9에서 직접 실습한다.
