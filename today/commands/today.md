---
description: 오늘 하루 Claude Code로 뭘 했는지 활동 요약을 보여줍니다
allowed-tools: Bash(find:*), Bash(grep:*), Bash(jq:*), Bash(date:*), Bash(ls:*), Bash(awk:*), Bash(cat:*), AskUserQuestion
---

## ⚠️ 필수: 먼저 날짜를 물어봐야 함!

**반드시 첫 번째로** AskUserQuestion 도구를 사용해서 날짜를 물어봐.
다른 어떤 작업도 하기 전에 먼저 물어봐야 해. 이 단계를 절대 건너뛰지 마.

```
AskUserQuestion:
  질문: "어느 날짜의 활동을 볼까요?"
  선택지: ["오늘", "어제"]
```

사용자가 선택할 때까지 기다린 후 아래 단계를 진행해.

---

Claude Code로 무엇을 했는지 **세션별로** 분석해서 보여줘.

## 실행 단계

1. **날짜 선택** (위에서 이미 완료됨)

2. **timestamp 범위 계산** (밀리초 단위)
   ```bash
   # 오늘 선택 시
   START_TS=$(($(date -d "today 00:00:00" +%s) * 1000))
   END_TS=$(($(date -d "tomorrow 00:00:00" +%s) * 1000))

   # 어제 선택 시
   START_TS=$(($(date -d "yesterday 00:00:00" +%s) * 1000))
   END_TS=$(($(date -d "today 00:00:00" +%s) * 1000))
   ```

3. **history.jsonl에서 해당 날짜의 프로젝트 추출**
   ```bash
   # timestamp 범위로 필터링해서 프로젝트별 프롬프트 수 집계
   cat ~/.claude/history.jsonl | jq -r "select(.timestamp >= $START_TS and .timestamp < $END_TS) | .project" | sort | uniq -c | sort -rn
   ```

4. **세션 파일 찾기 (timestamp 기반)**
   - 파일 수정 시간(-mtime)이 아닌, **세션 파일 내부의 timestamp**로 판단
   - 각 프로젝트 폴더의 세션 파일들을 검색해서 해당 날짜 timestamp가 포함된 세션만 선택
   ```bash
   # 프로젝트 폴더 경로 변환 예: /home/amos/project → -home-amos-project
   PROJECT_DIR=$(echo "/home/amos/project" | tr '/' '-' | sed 's/^-//')

   # 해당 프로젝트의 세션 파일들 중 해당 날짜 timestamp가 있는 것 찾기
   for f in ~/.claude/projects/${PROJECT_DIR}/*.jsonl; do
     if grep -q "\"timestamp\":17" "$f" 2>/dev/null; then
       # timestamp 범위 체크 로직
       grep -o '"timestamp":[0-9]*' "$f" | head -1 | grep -oP '[0-9]+' | while read ts; do
         if [ "$ts" -ge "$START_TS" ] && [ "$ts" -lt "$END_TS" ]; then
           echo "$f"
         fi
       done
     fi
   done
   ```

5. **각 세션별 요약 추출**
   - 각 세션 파일에서 `"type":"summary"` 항목을 찾아 세션 주제 파악
   ```bash
   grep '"type":"summary"' [세션파일] | jq -r '.summary'
   ```

6. **결과를 세션 기반 마크다운으로 출력**

```markdown
## 📊 Claude Code 활동 (YYYY-MM-DD)

### 총계
- 총 프롬프트: N개
- 작업한 프로젝트: N개
- 세션 수: N개

### 세션별 활동

#### 🖥️ project-a
| 시간 | 세션 | 주요 작업 |
|-----|------|---------|
| 09:30 | WiFi 모니터링 설정 | Grafana 대시보드 업데이트 |
| 14:00 | Docker 업데이트 | OpenWebUI 버전 업그레이드 |

#### 🚀 project-b
| 시간 | 세션 | 주요 작업 |
|-----|------|---------|
| 10:00 | TF-710 작업 | PR 생성 및 배포 |

### 프로젝트별 프롬프트 수
| 프로젝트 | 프롬프트 수 |
|---------|-----------|
| project-a | 30 |
```

7. **세션 시간순 정렬**
   - 세션 내 첫 timestamp 기준으로 정렬해서 시간 흐름대로 보여주기

**중요**: 파일 수정 시간(-mtime)이 아닌 세션 내부 timestamp로 판단해야 정확함!

지금 바로 위 단계들을 실행해서 세션별로 정리된 결과를 보여줘.
