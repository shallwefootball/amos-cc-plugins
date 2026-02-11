---
description: handoff 시스템을 설치합니다 (SessionStart hook + 글로벌 gitignore)
allowed-tools: Bash(git:*), Bash(cat:*), Bash(touch:*), Bash(grep:*), Read, Write, Edit
---

handoff 시스템을 설치합니다. 한 번만 실행하면 모든 프로젝트에서 사용 가능.

## 실행

### 1. SessionStart hook 추가

`~/.claude/settings.json`을 Read로 읽고, `hooks.SessionStart`가 없으면 추가해:

```json
"SessionStart": [
  {
    "matcher": "",
    "hooks": [
      {
        "type": "command",
        "command": "cat .handoff/latest.md 2>/dev/null || true"
      }
    ]
  }
]
```

**주의:**
- 기존 hooks가 있으면 유지하고 SessionStart만 추가
- 이미 SessionStart에 `.handoff` 관련 hook이 있으면 스킵
- Edit 도구로 정확하게 수정할 것

### 2. 글로벌 gitignore 설정

```bash
# 글로벌 gitignore 파일이 설정되어 있는지 확인
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

### 3. 완료 메시지

```
handoff 설치 완료!

설치된 항목:
- SessionStart hook: 새 세션 시작 시 .handoff/latest.md 자동 주입
- 글로벌 gitignore: .handoff/ 폴더 모든 프로젝트에서 무시

사용법:
- /handoff-init  ← 지금 한 거 (한 번만)
- /handoff       ← 세션 끝에 (작업 내용 저장)
- /compact       ← 작업 중 (압축 + 체크포인트)
- 새 세션        ← 자동으로 이전 handoff 주입됨
```
