---
description: 확정된 handoff를 대상 프로젝트의 .handoff/에 저장합니다.
allowed-tools: Bash(date:*), Bash(mkdir:*), Bash(ls:*), Read, Write, AskUserQuestion
---

대화에서 확정된 handoff 내용을 대상 프로젝트의 `.handoff/`에 저장해.
보통 `/handoff-draft`로 초안 만들고 수정한 뒤에 사용.

## 실행

### 1. 대상 경로 확인

유저가 `/handoff-inject <path>` 형태로 경로를 지정했으면 그 경로 사용.
경로가 없으면 AskUserQuestion으로 물어봐:
- 질문: "어느 프로젝트에 주입할까요? (경로)"

### 2. handoff 내용 확인

이 대화에서 가장 최근에 확정된 handoff 포맷 내용을 찾아.
(보통 `/handoff-draft` 후 수정을 거친 최종본)

찾으면 유저에게 보여주고 확인:
- "이 내용으로 주입할까요?"

못 찾으면 AskUserQuestion으로 내용을 붙여넣으라고 요청.

### 3. 기존 handoff 백업

대상 경로에 `.handoff/latest.md`가 있으면:

```bash
DATE=$(date +"%Y-%m-%d %H:%M:%S")
TIMESTAMP=$(date +"%Y-%m-%dT%H%M")
```

- Read로 기존 `latest.md` 읽기
- `.handoff/snapshots/{TIMESTAMP}.md`로 Write (백업)

### 4. 새 handoff 저장

```bash
mkdir -p <대상경로>/.handoff/snapshots
DATE=$(date +"%Y-%m-%d %H:%M:%S")
TIMESTAMP_NEW=$(date +"%Y-%m-%dT%H%M")
```

1. **`<대상경로>/.handoff/latest.md`** — Write
2. **`<대상경로>/.handoff/snapshots/{TIMESTAMP_NEW}.md`** — 스냅샷

### 5. 완료 메시지

```
handoff 주입 완료!
  → <대상경로>/.handoff/latest.md
  → <대상경로>/.handoff/snapshots/{TIMESTAMP_NEW}.md (스냅샷)
새 세션에서 자동으로 주입됩니다.
```
