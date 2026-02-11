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

### 4. 완료 메시지

```
handoff 설치 완료!

설치된 항목:
- ~/.claude/handoff-hook.sh (hook 스크립트)
- SessionStart hook: 새 세션 시작 시 <handoff-context> 태그로 자동 주입
- 글로벌 gitignore: .handoff/ 폴더 모든 프로젝트에서 무시

사용법:
- /handoff        세션 끝에 작업 내용 저장
- /handoff-draft  다른 세션에 넘길 초안 출력
- /handoff-inject 다른 세션에서 받은 내용을 대상 폴더에 주입
- /compact        작업 중 체크포인트 저장 + 압축
```
