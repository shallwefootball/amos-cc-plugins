---
description: 현재 세션의 작업 여정을 프로젝트 폴더에 문서로 정리합니다
allowed-tools: Bash(date:*), Bash(git:*), Bash(basename:*), Bash(pwd:*), Bash(mkdir:*), Bash(ls:*), Read, Write, AskUserQuestion
---

현재 세션의 작업 여정(동기→접근→시행착오→레퍼런스→인사이트→결과)을 프로젝트 폴더에 문서로 남겨.

## 실행

### 1. 메타정보 수집

```bash
PROJECT=$(basename $(pwd))
BRANCH=$(git branch --show-current 2>/dev/null || echo "N/A")
COMMIT=$(git rev-parse --short HEAD 2>/dev/null || echo "N/A")
DATE=$(date +"%Y-%m-%d %H:%M:%S")
NOW=$(date +"%Y%m%d-%H%M%S")
```

### 2. 저장 위치 결정

AskUserQuestion으로 저장 경로를 물어봐:

- 옵션: `docs/recaps/` (기본값), 직접 입력
- 사용자가 기본값 선택하거나 응답 없으면 → `docs/recaps/` 사용

```bash
mkdir -p "$RECAP_DIR"
```

### 3. 세션 대화 분석

전체 대화를 돌아보고 다음 6가지를 추출해:

- **배경** — 왜 이 작업을 시작했는지 (동기, 맥락)
- **접근** — 어떤 설계 판단을 내렸는지 (선택한 방향과 이유)
- **과정** — 시행착오 기록
  - 성공한 것
  - 실패한 것 (왜 안 됐는지 포함)
- **레퍼런스** — 참고한 문서, 링크, 코드, 라이브러리
- **인사이트** — 이 과정에서 얻은 깨달음, 재사용 가능한 지식
- **결과** — 최종 산출물, 변경된 파일 목록

**작성 원칙:**
- 없는 항목은 섹션 자체를 생략
- 나중에 읽어도 맥락을 이해할 수 있게 구체적으로
- 코드 경로는 반드시 포함
- 간결하되 핵심은 빠짐없이

### 4. 제목 결정

- `/recap "제목"` 형태로 인자가 있으면 → 그대로 사용
- 인자가 없으면 → 세션 내용을 보고 자동 생성 (15-40자, 핵심 주제 요약)

### 5. 파일 저장

```bash
# 제목에서 특수문자 제거
SAFE_TITLE=$(echo "$TITLE" | sed 's/[^a-zA-Z0-9가-힣 ]//g' | sed 's/ /-/g')
FILENAME="${NOW}-${SAFE_TITLE}.md"

# 디렉토리 생성
mkdir -p "$RECAP_DIR"
```

파일 내용은 아래 템플릿으로 Write:

```markdown
---
title: [제목]
date: [YYYY-MM-DD HH:mm:ss]
project: [프로젝트명]
branch: [브랜치명]
commit: [커밋 해시]
tags:
  - recap
---

# [제목]

## 배경
(동기, 맥락)

## 접근
(설계 판단, 선택한 방향과 이유)

## 과정

### 성공한 것
(효과가 있었던 방법)

### 실패한 것
(시도했지만 안 된 것과 이유)

## 레퍼런스
(참고한 문서, 링크, 코드)

## 인사이트
(깨달음, 재사용 가능한 지식)

## 결과

### 변경 파일
- `path/to/file` — 설명
```

**중요**: 내용이 없는 섹션은 템플릿에서 제거하고 저장해.

### 6. 완료 메시지

```bash
# 누적 recap 수 세기
COUNT=$(ls "$RECAP_DIR"/*.md 2>/dev/null | wc -l)
```

```
recap 저장 완료!
  → {FILENAME}
  → {RECAP_DIR}
  → 누적 {COUNT}개
```

## 실행 지시

지금 바로 위 로직을 실행해서 세션 내용을 정리해줘.

**핵심:**
1. 저장 경로 물어보기 → 기본값 `docs/recaps/`
2. 전체 대화를 돌아보며 6가지 항목 추출 (없는 건 생략)
3. 제목 결정 (인자 또는 자동 생성)
4. 파일 저장 후 완료 메시지
