---
description: handoff 시스템을 설치합니다 (hook 스크립트 + SessionStart hook + 글로벌 gitignore)
allowed-tools: Bash(git:*), Bash(cat:*), Bash(touch:*), Bash(grep:*), Bash(cp:*), Bash(chmod:*), Read, Write, Edit
---

handoff 시스템을 설치합니다. 한 번만 실행하면 모든 프로젝트에서 사용 가능.

## 실행

### 1. hook 스크립트 설치

`~/.claude/plugins/marketplaces/cc-toolkit/tools/commands/handoff-hook.sh`를 `~/.claude/`로 복사:

```bash
cp ~/.claude/plugins/marketplaces/cc-toolkit/tools/commands/handoff-hook.sh ~/.claude/handoff-hook.sh
chmod +x ~/.claude/handoff-hook.sh
```

이미 있으면 덮어쓰기.

### 2. SessionStart hook 추가

`~/.claude/settings.json`을 Read로 읽고, `hooks.SessionStart`가 없으면 추가해:

```json
"SessionStart": [
  {
    "matcher": "",
    "hooks": [
      {
        "type": "command",
        "command": "bash ~/.claude/handoff-hook.sh"
      }
    ]
  }
]
```

**주의:**
- 기존 hooks가 있으면 유지하고 SessionStart만 추가
- 이미 SessionStart에 `handoff` 관련 hook이 있으면 스킵
- Edit 도구로 정확하게 수정할 것

### 3. 글로벌 gitignore 설정

```bash
git config --global core.excludesfile
```

설정 안 되어 있으면:
```bash
touch ~/.gitignore_global
git config --global core.excludesfile ~/.gitignore_global
```

`.handoff/`가 글로벌 gitignore에 없으면 추가:
```bash
grep -q "^\.handoff/$" ~/.gitignore_global 2>/dev/null || echo ".handoff/" >> ~/.gitignore_global
```

### 4. 현재 handoff 확인

설치 완료 후 `.handoff/latest.md`를 Read로 확인해:

**있으면:**
```
handoff 설치 완료! 이전 handoff를 발견했습니다:
```
내용을 보여주고 바로 작업을 안내해.

**없으면:**
```
handoff 설치 완료! 현재 handoff 없음.

시작하려면:
- 바로 작업 시작 → 세션 끝에 /handoff로 저장
- 다른 세션에서 받을 내용이 있으면 → /handoff-inject
```
