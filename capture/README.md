# capture

클로드 코드 대화 내용을 옵시디언 볼트에 캡처하는 플러그인입니다.

## 왜 필요한가요?

클로드와 대화하면서 이런 경험 있으시죠?

```
나: "야 이 프로젝트에서 해야할 일들 쭉 정리해봐"
클로드: [10개 태스크 완벽 정리...]
       1. DB 마이그레이션
       2. API 엔드포인트 수정
       3. 테스트 코드 작성
       ...

나: "좋아 1번부터 하나씩 하자"
클로드: [작업 진행...]
       [대화가 계속됨...]
       [화면이 아래로 쭉쭉...]

나: "어? 아까 정리한 TODO 리스트 어디갔지? 🤔 스크롤 올려야하나..."
```

**문제:** 클로드가 잘 정리해준 내용이 대화 속에 묻힘
**해결:** 정리된 내용을 옵시디언에 캡처해서 **옆에 띄워두고 보면서 작업**

## 실제 사용 흐름

```bash
# 1. 클로드한테 정리 요청
"야 이거 분석/정리 좀 해봐"

# 2. 클로드가 잘 정리해줌
[클로드의 완벽한 정리 내용...]

# 3. 옵시디언으로 캡처
/capture "프로젝트 TODO 리스트"
✅ 저장 완료!

# 4. 옵시디언 열어서 문서 보면서 작업
# - TODO 리스트 보면서 하나씩 체크
# - 아키텍처 문서 보면서 코딩
# - 분석 결과 보면서 버그 수정
```

## 설치

```bash
# 마켓플레이스에서 설치
/plugin marketplace add shallwefootball/amos-cc-plugins
/plugin install capture@amos-cc-plugins
```

## 사용법

```bash
# 제목 자동 생성
/capture

# 제목 직접 입력
/capture "노트 제목"
```

직전 어시스턴트 응답을 옵시디언 볼트에 저장합니다.
제목을 입력하지 않으면 응답 내용을 보고 자동으로 생성됩니다.

## 기능

- 클로드가 정리한 내용을 바로 옵시디언 노트로 저장
- 풍부한 메타데이터 자동 생성 (날짜, 프로젝트, Git 정보 등)
- iCloud 동기화 지원 (Mac ↔️ 리모트)
- 타임스탬프 기반 파일명 자동 생성

## 저장 위치

```
~/Library/Mobile Documents/iCloud~md~obsidian/Documents/shallwefootball/Claude-Snapshots/
```

## 생성되는 메타데이터

```yaml
---
title: 노트 제목
created: 2025-12-03 14:30:22
tags:
  - claude-code
  - capture
project: 프로젝트명
working_directory: /path/to/project
git_branch: main
git_commit: a1b2c3d
---
```

## 파일명 형식

```
YYYYMMDD-HHmmss-제목.md
```

예: `20251203-143022-레포지토리-분석.md`

## iCloud 동기화

iCloud가 자동으로 Mac과 리모트 환경 간 동기화를 처리합니다.
