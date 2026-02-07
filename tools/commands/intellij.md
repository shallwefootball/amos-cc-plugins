---
description: 디렉토리를 IntelliJ IDEA CE에서 엽니다
---

지정된 디렉토리(또는 현재 디렉토리)를 IntelliJ IDEA CE에서 엽니다.

## 실행 방법

사용자가 경로를 제공했는지 확인:
- **경로 제공됨**: 해당 경로를 엽니다
- **경로 없음**: 현재 디렉토리(`.`)를 엽니다

다음 명령어를 실행:

```bash
open -a "IntelliJ IDEA CE" [경로 또는 .]
```

## 응답

실행 후:
- 성공하면: "IntelliJ IDEA CE에서 `[절대 경로]`를 열었습니다."
- 실패하면: "IntelliJ IDEA CE를 찾을 수 없습니다."
