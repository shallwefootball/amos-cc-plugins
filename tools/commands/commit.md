---
description: 변경사항을 의미 단위로 쪼개서 커밋합니다. Use when the user asks to commit, says "커밋해", "커밋하고 push해", "commit changes", "변경사항 저장", or asks to save/push their work to git. ALWAYS use this skill instead of manual git commit.
allowed-tools: Bash(git:*)
---

변경사항을 분석하고 의미 단위로 쪼개서 커밋합니다.

## 실행

### 1. 현재 상태 파악

```bash
git status
git diff
git diff --staged
```

### 2. 의미 단위 분리

변경사항을 분석해서 **독립적인 의미 단위**로 그룹핑하세요:
- 하나의 커밋 = 하나의 목적
- 관련 없는 변경은 별도 커밋으로
- 리팩토링과 기능 추가는 분리
- 설정 변경과 코드 변경은 분리

### 3. 커밋 메시지 작성

Conventional Commits 형식:
```
<type>(<scope>): <description>
```

타입:
- `feat`: 새 기능
- `fix`: 버그 수정
- `refactor`: 리팩토링
- `chore`: 설정, 빌드, 의존성
- `docs`: 문서
- `test`: 테스트
- `style`: 포맷팅

규칙:
- 영어로 작성
- 소문자 시작
- 현재형 ("add" not "added")
- 50자 이내
- "why"를 담되 간결하게

### 4. 커밋 실행

각 의미 단위마다:
```bash
git add <관련 파일들>
git commit -m "<message>

Paired with Opus 4.6"
```

**주의:**
- `git add -A` 사용 금지. 파일 단위로 add.
- `.env`, credentials 등 민감 파일 제외
- 커밋 순서: 의존성 있으면 의존 대상 먼저

### 5. 결과 보고

모든 커밋 완료 후 요약:
```
N개 커밋 완료:
- <hash> <message>
- <hash> <message>
```
