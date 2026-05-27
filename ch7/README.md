# 챕터 7. 실무 배포 전략을 배우고 이를 마이크로서비스에 적용하기

### 다루는 내용
- 7.2: Rolling Update, Blue-Green, Canary 등 다양한 배포 전략들
- 7.3: Rolling Update 배포 실습
- 7.4: Argo Rollouts 설치 및 구성
- 7.5: Blue-Green 배포 실습
- 7.6: Canary 배포 실습
- 7.7: Worklog App의 백엔드와 DB (서비스 구성)
- 7.8: [GitHub] Worklog App 배포해보기
- 7.9: [Jenkins] Worklog App 배포해보기
- 7.10: [GitLab] Worklog App 배포해보기

### 설계 노트 (강의자 참고)

> **"마이크로서비스"라는 용어에 대하여** (2026-05 sungmin 확인)
>
> worklog-frontend + worklog-backend + MongoDB 구성을 엄밀한 의미의 마이크로서비스라고 보기는 어려울 수 있습니다.
> 이는 일반적인 **3-tier 웹 애플리케이션 구조**에 가깝습니다.
>
> 이 구성을 사용하는 **주요 의도**는 다음과 같습니다:
> - 실제 CI/CD 운용 시 단일 서비스만 배포하는 것이 아니라, downstream 서비스들의 변경사항을 고려해야 함을 보여주기 위함
> - 예: frontend에 새 기능을 추가하려면, 해당 기능을 지원하는 API가 backend에서 먼저 제공되어야 하므로 backend 배포가 선행되어야 함
>
> 강의에서 이 부분을 명확히 짚고 넘어갈 예정. (Seongju Mun co-assist 검토 의견 반영)
