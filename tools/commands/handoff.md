---
description: 현재 작업 context를 정리해서 .handoff/에 저장합니다. 새 세션에서 자동 주입됩니다.
allowed-tools: Bash(date:*), Bash(git:*), Bash(basename:*), Bash(pwd:*), Bash(mkdir:*), Read, Write
---

현재 세션의 작업 상태를 정리해서 `.handoff/`에 저장해.
다음 세션에서 SessionStart hook이 `.handoff/latest.md`를 자동 주입함.

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

이 세션에서 나눈 대화를 돌아보고 다음 템플릿으로 정리해:

```markdown
# Handoff: {프로젝트명} ({날짜})
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

**작성 원칙:**
- **2,000 토큰(~8KB) 이내** — hook에서 초과분은 잘림
- 파일 내용 복사 금지. **경로 + 라인 범위만** (`file:L10-50`)
- 코드 스니펫 최소 (3줄 이내, 꼭 필요할 때만)
- 빈 섹션은 삭제
- "~했다"가 아닌 **"~해야 한다"** (다음 세션의 행동 지침)

### 3. 저장

2개 파일에 저장:

1. **`.handoff/latest.md`** — Write로 작성 (덮어쓰기)
2. **`.handoff/snapshots/{TIMESTAMP}.md`** — 같은 내용으로 Write (스냅샷)

### 4. 완료 메시지

```
handoff 저장 완료!
  → .handoff/latest.md (자동 주입용)
  → .handoff/snapshots/{TIMESTAMP}.md (스냅샷)
다음 세션에서 자동으로 주입됩니다. (2,000 토큰 예산)
```
