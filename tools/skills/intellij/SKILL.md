---
description: 디렉토리를 IntelliJ IDEA CE에서 엽니다
allowed-tools: Bash(uname:*), Bash(open:*), Bash(idea:*), Bash(which:*)
---

지정된 디렉토리(또는 현재 디렉토리)를 IntelliJ IDEA CE에서 엽니다.

## 실행 방법

1. 타겟 경로 결정: `$ARGUMENTS` 또는 현재 디렉토리(`.`)

2. OS 감지 후 실행:

```bash
OS=$(uname -s)
```

- **macOS** (`Darwin`): `open -a "IntelliJ IDEA CE" [경로]`
- **Linux**: `idea [경로]` (또는 `/snap/bin/intellij-idea-community [경로]`)

3. 성공하면: "IntelliJ IDEA CE에서 `[절대 경로]`를 열었습니다."
4. 실패하면: "IntelliJ IDEA CE를 찾을 수 없습니다. 설치 경로를 확인하세요."
