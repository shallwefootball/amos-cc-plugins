---
description: 클로드 코드 대화 내용을 옵시디언 볼트에 캡처합니다
---

사용자가 방금 전 대화에서 클로드가 정리한 내용을 옵시디언 노트로 저장하고 싶어해.

## 실행 단계

1. **사용자 입력 파싱**
   - `/capture` 또는 `/capture "제목"` 형태로 호출됨
   - 제목이 제공되면 그대로 사용
   - 제목이 없으면 **직전 어시스턴트 응답 내용을 보고 자동으로 제목 생성**
     - 응답 내용의 핵심 주제를 파악해서 간결한 제목 만들기 (10-30자)
     - 예: "amos-cc-plugins 레포 분석", "capture 플러그인 구현", "TODO 리스트" 등

2. **캡처할 내용 결정**
   - **중요**: 이 커맨드가 실행되기 **바로 직전**에 네가 작성한 어시스턴트 응답을 캡처해야 함
   - 현재 대화에서 가장 마지막 어시스턴트 메시지의 전체 내용을 가져와
   - 툴 호출 결과는 제외하고, 순수 어시스턴트 텍스트 응답만 포함
   - 마크다운 형식이면 그대로 유지

3. **메타데이터 생성**
   현재 세션 정보를 기반으로 풍부한 frontmatter 생성:
   ```yaml
   ---
   title: [사용자가 입력한 제목]
   created: [YYYY-MM-DD HH:mm:ss]
   tags:
     - claude-code
     - capture
   project: [현재 프로젝트명 또는 디렉토리명]
   working_directory: [pwd]
   git_branch: [현재 브랜치, git repo인 경우]
   git_commit: [현재 커밋 해시, git repo인 경우]
   ---
   ```

4. **파일명 생성**
   - 형식: `YYYYMMDD-HHmmss-제목.md`
   - 예: `20251203-143022-레포지토리-분석.md`
   - 파일명에서 특수문자 제거 (공백은 하이픈으로)

5. **옵시디언 볼트에 저장**
   - 경로: `/Users/amos/Library/Mobile Documents/iCloud~md~obsidian/Documents/shallwefootball/Claude-Snapshots/`
   - 디렉토리가 없으면 생성
   - 파일 작성 후 성공 메시지 출력

6. **저장된 파일 정보 표시**
   ```markdown
   ✅ 캡처 완료!

   📄 파일: 20251203-143022-레포지토리-분석.md
   📁 위치: shallwefootball/Claude-Snapshots/
   🔗 iCloud 동기화: 활성화됨 (Mac ↔️ 리모트)
   ```

## 실행 예시

```bash
# 현재 날짜/시간 가져오기
NOW=$(date +"%Y%m%d-%H%M%S")
DATE=$(date +"%Y-%m-%d %H:%M:%S")

# Git 정보 (있으면)
if git rev-parse --git-dir > /dev/null 2>&1; then
  BRANCH=$(git branch --show-current 2>/dev/null || echo "detached")
  COMMIT=$(git rev-parse --short HEAD 2>/dev/null || echo "N/A")
fi

# 프로젝트명 추출
PROJECT=$(basename $(pwd))

# 파일명 생성 (제목에서 특수문자 제거)
TITLE="[사용자 입력 제목]"
FILENAME="${NOW}-${TITLE}.md"

# 볼트 경로
VAULT_PATH="/Users/amos/Library/Mobile Documents/iCloud~md~obsidian/Documents/shallwefootball/Claude-Snapshots"

# 디렉토리 생성
mkdir -p "$VAULT_PATH"

# 파일 작성
cat > "$VAULT_PATH/$FILENAME" <<'EOF'
---
title: $TITLE
created: $DATE
tags:
  - claude-code
  - capture
project: $PROJECT
working_directory: $(pwd)
git_branch: $BRANCH
git_commit: $COMMIT
---

# $TITLE

[여기에 직전 어시스턴트 응답 내용 삽입]

---
*Captured from Claude Code on $DATE*
EOF
```

## 실행 지시

지금 바로 위 로직을 실행해서 사용자의 요청을 처리해줘.

**중요한 단계:**
1. **현재 대화에서 이 커맨드 실행 직전의 마지막 어시스턴트 응답을 찾아**
2. 그 응답 내용 전체를 변수에 저장해
3. 사용자가 제목을 입력했는지 확인:
   - 제목이 있으면: 그 제목 사용
   - 제목이 없으면: 응답 내용을 보고 적절한 제목 자동 생성 (10-30자, 핵심 주제 요약)
4. 위 bash 스크립트를 실행하되, `[여기에 직전 어시스턴트 응답 내용 삽입]` 부분에 실제 어시스턴트 응답 내용을 넣어
5. 파일 저장 후 성공 메시지 출력

**어시스턴트 응답 캡처 시 주의사항:**
- 툴 사용 블록(`<function_calls>`)은 제외
- 순수 텍스트 응답만 포함
- 마크다운 형식 유지
- 전체 내용을 빠짐없이 포함
