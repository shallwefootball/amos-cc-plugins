---
description: 어제 하루 Claude Code로 뭘 했는지 활동 요약을 보여줍니다
allowed-tools: Bash(find:*), Bash(grep:*), Bash(jq:*), Bash(date:*), Bash(ls:*), Bash(awk:*), Bash(cat:*)
---

**어제** Claude Code로 무엇을 했는지 **세션별로** 분석해서 보여줘.

## 실행 단계

1. **어제 timestamp 범위 계산** (밀리초 단위)
   ```bash
   START_TS=$(($(date -d "yesterday 00:00:00" +%s) * 1000))
   END_TS=$(($(date -d "today 00:00:00" +%s) * 1000))
   ```

2. **history.jsonl에서 어제의 프로젝트 추출**
   ```bash
   cat ~/.claude/history.jsonl | jq -r "select(.timestamp >= $START_TS and .timestamp < $END_TS) | .project" | sort | uniq -c | sort -rn
   ```

3. **세션 파일 찾기** — 각 프로젝트 폴더의 세션 파일에서 어제 timestamp가 포함된 것만 선택
   - 프로젝트 경로 → 폴더명 변환: `/home/amos/project` → `-home-amos-project`
   - `grep -l` 로 어제 날짜 패턴이 있는 .jsonl 파일 필터링
   - agent-* 파일 제외

4. **각 세션별 요약** — `"type":"summary"` 항목에서 세션 주제 파악

5. **세션 기반 마크다운으로 출력** — 시간순 정렬

```markdown
## 어제의 Claude Code 활동 (YYYY-MM-DD)

### 총계
- 총 프롬프트: N개 | 프로젝트: N개 | 세션: N개

### 세션별 활동

#### project-a
| 시간 | 세션 | 주요 작업 |
|-----|------|---------|

### 프로젝트별 프롬프트 수
| 프로젝트 | 프롬프트 수 |
|---------|-----------|
```

**중요**: 파일 수정 시간(-mtime)이 아닌 세션 내부 timestamp로 판단해야 정확함!
