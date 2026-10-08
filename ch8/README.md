# 챕터 8. 실무에서 가장 많이 사용되는 배포 패턴 (모범 사례)

PR/Branch/Tag 기반 멀티 환경(dev/staging/prod) 배포와 Full CI/CD(Argo CD 자동 sync) 워크플로우를 GitHub Actions와 Jenkins로 각각 구현합니다. GitLab CI는 10장에서 다룹니다.

### 다루는 내용
- 8.2: 멀티환경 배포의 개념 (namespace 분리 + PR/Branch/Tag 패턴)
- 8.3: [GitHub] PR/Branch/Tag 기반 멀티환경 파이프라인
- 8.4: [GitHub] Full CI/CD workflow (Argo CD)
- 8.5: [Jenkins] PR/Branch/Tag 기반 멀티환경 파이프라인
- 8.6: [Jenkins] Full CI/CD workflow (Argo CD)

> 마이크로서비스(Frontend + Backend + MongoDB) 전체 스택의 빌드/배포 자체는 ch7.7~7.9에서 다룹니다. 본 장은 그 위에 멀티환경 + GitOps 패턴을 얹습니다.
