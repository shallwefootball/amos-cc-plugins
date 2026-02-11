---
description: 대화를 압축하고 .handoff/ 체크포인트를 저장합니다.
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
mkdir -p .handoff
```

### 2. 작업 내용 정리

/handoff와 같은 포맷으로 현재 상태를 정리해:

```markdown
# Handoff: {프로젝트명} ({날짜}) [checkpoint]

## 목표
## 현재 상태
## 핵심 파일
## 성공한 접근
## 실패한 접근
## 남은 것
## 주의
```

단, /handoff보다 가볍게 — 핵심만 빠르게 정리. compact는 자주 할 수 있으니까.

### 3. 저장

1. **`.handoff/latest.md`** — Write로 덮어쓰기
2. **`.handoff/{TIMESTAMP}.md`** — 스냅샷
3. **`.handoff/history.log`** — 한 줄 추가:
   ```
   [{DATE}] (compact) {현재 상태 요약 한 줄}
   ```

### 4. 압축 실행

저장 완료 후 사용자에게 안내:

```
체크포인트 저장 완료!
  → .handoff/latest.md 갱신
  → .handoff/{TIMESTAMP}.md 스냅샷

이제 /compact 를 직접 실행해서 대화를 압축하세요.
```

**중요:** 이 커맨드가 Claude Code 내장 /compact를 직접 실행할 수는 없음. 체크포인트 저장 후 사용자가 직접 /compact 실행.
