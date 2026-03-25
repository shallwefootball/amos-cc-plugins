---
description: 작업 상태를 .handoff/에 체크포인트로 저장합니다. /compact 전에 사용.
allowed-tools: Bash(date:*), Bash(git:*), Bash(basename:*), Bash(pwd:*), Bash(mkdir:*), Read, Write
---

대화를 압축하기 전에 현재 작업 상태를 .handoff/에 체크포인트로 저장해.
세션이 갑자기 끊겨도 마지막 체크포인트가 남아있음.

## 실행

### 1. 현재 상태 수집

```bash
PROJECT=$(basename $(pwd))
BRANCH=$(git branch --show-current 2>/dev/null || echo "N/A")
DATE=$(date +"%Y-%m-%d %H:%M:%S")
TIMESTAMP=$(date +"%Y-%m-%dT%H%M")
mkdir -p .handoff/snapshots
```

### 2. 작업 내용 정리

/handoff와 같은 포맷으로 현재 상태를 정리해:

```markdown
# Handoff: {프로젝트명} ({날짜}) [checkpoint]
## Status: in_progress | blocked | review

## 목표
(1~2줄)

## 현재 상태
(어디까지 했는지)

## 핵심 파일
- `path/to/file:L50-120` — 무엇을, 왜

## 다음 할 일
1. (우선순위 순)

<!-- 해당될 때만 포함 -->
## 결정 사항
- [결정]: [이유] (영향: [파일들])

## 실패한 접근
- [방법]: [왜 안 됐는지]

## 주의
- [제약사항]
```

단, /handoff보다 가볍게 — 핵심만 빠르게 정리. checkpoint는 자주 할 수 있으니까.

**작성 원칙:**
- **2,000 토큰(~8KB) 이내**
- 파일 내용 복사 금지. **경로 + 라인 범위만** (`file:L10-50`)
- 빈 섹션은 삭제
- "~해야 한다" 형식

### 3. 저장

1. **`.handoff/latest.md`** — Write로 덮어쓰기
2. **`.handoff/snapshots/{TIMESTAMP}.md`** — 스냅샷

### 4. 압축 실행

저장 완료 후 사용자에게 안내:

```
체크포인트 저장 완료!
  → .handoff/latest.md 갱신
  → .handoff/snapshots/{TIMESTAMP}.md 스냅샷

이제 /compact 를 직접 실행해서 대화를 압축하세요.
```

**중요:** 이 커맨드가 Claude Code 내장 /compact를 직접 실행할 수는 없음. 체크포인트 저장 후 사용자가 직접 /compact 실행.
