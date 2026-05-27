# PR / Branch / Tag 기반 배포 패턴 이해
## Review deployment patterns:
### PR-based: PR 생성 시 preview 환경(dev)에 배포, PR merge 시 다음 환경으로 배포
### Branch-based: main → dev, release/* → staging
### Tag-based: v*.*.* → production

# Create example branches for demonstration
## develop 브랜치 생성 및 push
cd ~/workspace/worklog-backend
git checkout -b develop
git push origin develop

## release/1.0 브랜치 생성 및 push
git checkout -b release/1.0
git push origin release/1.0

## main 브랜치로 복귀
git checkout main
