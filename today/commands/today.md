---
description: 오늘 하루 Claude Code로 뭘 했는지 활동 요약을 보여줍니다
---

# 오늘의 Claude Code 활동 요약

오늘 하루 동안 Claude Code로 무엇을 했는지 분석합니다.

## 분석 방법

1. **히스토리 파일 읽기**
   - `~/.claude/history.jsonl` 파일에서 오늘 날짜 timestamp 항목 추출
   - timestamp는 Unix milliseconds 형식
   - `grep -a` 옵션으로 binary file 이슈 방지

2. **오늘 날짜 필터링**
   - 오늘 자정(00:00:00) 이후의 timestamp만 필터링
   - timestamp 패턴: 현재 날짜의 Unix ms 값으로 grep

3. **프로젝트별 그룹핑**
   - 각 프로젝트에서 입력한 프롬프트 수 집계
   - 프로젝트 경로에서 폴더명 추출

4. **세션 요약 확인** (선택)
   - `~/.claude/projects/` 하위의 오늘 수정된 세션 파일에서
   - `"type":"summary"` 항목이 있으면 활용

## 출력 형식

마크다운으로 깔끔하게 정리:

```markdown
## 📊 오늘의 Claude Code 활동 (YYYY-MM-DD)

### 총계
- 총 프롬프트: N개
- 작업한 프로젝트: N개

### 프로젝트별 활동
| 프로젝트 | 프롬프트 수 |
|---------|-----------|
| project-a | 30 |
| project-b | 15 |

### 주요 작업 내용
- **project-a**: [세션 요약 또는 주요 프롬프트 내용]
- **project-b**: [세션 요약 또는 주요 프롬프트 내용]
```

## 실행 예시

```bash
# 오늘 자정 timestamp 계산 (밀리초)
today_prefix=$(date +%s | cut -c1-5)  # 대략적인 prefix

# 오늘 항목 추출
grep -a "\"timestamp\":${today_prefix}" ~/.claude/history.jsonl

# 프로젝트별 집계
... | jq -r '.project' | sort | uniq -c
```

**참고**: 데이터가 없으면 "오늘은 아직 Claude Code 사용 기록이 없습니다" 출력
