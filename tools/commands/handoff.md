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
mkdir -p .handoff
```

### 2. 작업 내용 정리

이 세션에서 나눈 대화를 돌아보고 다음을 정리해:

```markdown
# Handoff: {프로젝트명} ({날짜})

## 목표
(이 세션에서 하려고 했던 것 — 1~2줄)

## 현재 상태
(어디까지 했는지 — 구체적으로)

## 핵심 파일
- `path/to/file` — 설명
- `path/to/file` — 설명

## 성공한 접근
(효과가 있었던 방법, 결정한 사항)

## 실패한 접근
(시도했지만 안 된 것 — 새 세션에서 같은 삽질 방지)

## 남은 것
- [ ] 아직 안 한 것
- [x] 이미 한 것

## 주의
(하지 말아야 할 것, 알아둬야 할 제약사항)
```

**작성 원칙:**
- 새 클로드가 코드 안 봐도 바로 이해할 수 있게
- "핵심 파일"에 경로 반드시 포함 (탐색 시간 절약)
- "실패한 접근"에 왜 안 됐는지 이유도 적기 (같은 삽질 방지)

### 3. 저장

3개 파일에 저장:

1. **`.handoff/latest.md`** — Write로 작성 (덮어쓰기)
2. **`.handoff/{TIMESTAMP}.md`** — 같은 내용으로 Write (스냅샷)
3. **`.handoff/history.log`** — 한 줄 추가:
   ```
   [{DATE}] (handoff) {목표 요약 한 줄}
   ```

### 4. 완료 메시지

```
handoff 저장 완료!
  → .handoff/latest.md (자동 주입용)
  → .handoff/{TIMESTAMP}.md (스냅샷)
다음 세션에서 자동으로 주입됩니다.
```
