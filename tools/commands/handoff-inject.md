---
description: 다른 세션에서 받은 handoff를 현재 프로젝트 .handoff/에 주입합니다.
allowed-tools: Bash(date:*), Bash(git:*), Bash(basename:*), Bash(pwd:*), Bash(mkdir:*), Bash(ls:*), Read, Write, AskUserQuestion
---

다른 세션에서 받은 handoff 내용을 현재 프로젝트의 `.handoff/`에 주입해.
기존 handoff가 있으면 스냅샷으로 보존.

## 실행

### 1. 기존 handoff 확인

```bash
mkdir -p .handoff
ls .handoff/latest.md 2>/dev/null
```

기존 `latest.md`가 있으면 유저에게 알려줘:
```
기존 handoff가 있습니다:
```
Read로 `.handoff/latest.md` 첫 줄을 보여주고 계속 진행할지 확인.
(기존 건 타임스탬프 스냅샷으로 자동 보존되니까 데이터 손실 없음)

### 2. 내용 받기

AskUserQuestion으로 물어봐:
- 질문: "주입할 handoff 내용을 붙여넣어 주세요"
- 선택지 없이 텍스트 입력만 받기

또는 유저가 `/handoff inject` 뒤에 바로 내용을 붙여넣었으면 그걸 사용.

### 3. 기존 handoff 백업

기존 `latest.md`가 있으면:
```bash
DATE=$(date +"%Y-%m-%d %H:%M:%S")
TIMESTAMP=$(date +"%Y-%m-%dT%H%M")
```
- 현재 `latest.md` 내용을 `.handoff/{TIMESTAMP}.md`로 Write (백업)
- `.handoff/history.log`에 추가:
  ```
  [{DATE}] (archived) 기존 handoff 백업 → {TIMESTAMP}.md
  ```

### 4. 새 handoff 저장

```bash
TIMESTAMP_NEW=$(date +"%Y-%m-%dT%H%M")
```

1. **`.handoff/latest.md`** — 새 내용으로 Write (덮어쓰기)
2. **`.handoff/{TIMESTAMP_NEW}.md`** — 같은 내용으로 스냅샷
3. **`.handoff/history.log`** — 한 줄 추가:
   ```
   [{DATE}] (inject) {내용의 목표 요약 한 줄}
   ```

### 5. 완료 메시지

```
handoff 주입 완료!
  → .handoff/latest.md 갱신
  → .handoff/{TIMESTAMP_NEW}.md 스냅샷
  → 기존 handoff는 .handoff/{TIMESTAMP}.md에 보존됨
```
