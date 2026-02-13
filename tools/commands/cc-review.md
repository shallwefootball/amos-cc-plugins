---
description: 오늘의 Claude Code 사용 패턴을 분석하고 활용 개선점을 제안합니다
allowed-tools: Bash(find:*), Bash(grep:*), Bash(jq:*), Bash(date:*), Bash(ls:*), Bash(cat:*), Bash(awk:*), Bash(wc:*)
---

오늘의 Claude Code **사용 패턴을 분석**하고, 더 잘 쓸 수 있는 구체적 개선점을 제안해줘.

## 실행 단계

### 1. 오늘 세션 데이터 수집

```bash
START_TS=$(($(date -d "today 00:00:00" +%s) * 1000))
END_TS=$(($(date -d "tomorrow 00:00:00" +%s) * 1000))
```

```bash
# 오늘 수정된 세션 파일
find ~/.claude/projects/ -name "*.jsonl" -mtime 0 ! -name "agent-*" -exec ls -lt {} \; 2>/dev/null | head -30
```

### 2. 사용 패턴 분석

각 세션 파일에서 추출:

**a) 프롬프트 패턴**
- 평균 프롬프트 길이 (짧은 = 구체적, 긴 = 모호할 수 있음)
- "고쳐줘", "다시", "아니" 같은 재시도 키워드 빈도
- 한 번에 여러 요청을 담은 프롬프트 비율

```bash
# 오늘 세션에서 user 메시지 추출
for f in $(find ~/.claude/projects/ -name "*.jsonl" -mtime 0 ! -name "agent-*" 2>/dev/null); do
  grep -a '"role":"human"' "$f" 2>/dev/null | tail -20
done
```

**b) 도구 활용 패턴**
- 서브에이전트 사용 횟수 (Task tool)
- Plan Mode 진입 횟수
- `/compact`, `/clear` 사용 여부

```bash
# 도구 사용 패턴
for f in $(find ~/.claude/projects/ -name "*.jsonl" -mtime 0 ! -name "agent-*" 2>/dev/null); do
  grep -ao '"tool_name":"[^"]*"' "$f" 2>/dev/null | sort | uniq -c | sort -rn | head -10
done
```

**c) 모델 전환 패턴**
- 어떤 모델을 주로 썼는지
- 작업 난이도 대비 적절했는지

**d) 세션 수명**
- 평균 세션 길이 (턴 수)
- `/compact` 없이 긴 세션이 있었는지
- `/clear`로 깔끔하게 끊었는지

### 3. 개선점 도출

수집된 데이터 기반으로 아래 카테고리별 분석:

| 카테고리 | 잘한 점 | 개선 포인트 |
|---------|--------|-----------|
| 프롬프트 품질 | | |
| 컨텍스트 관리 | | |
| 모델 선택 | | |
| 도구 활용 | | |
| 작업 흐름 | | |

### 4. 결과 출력

```markdown
## CC Review - [날짜]

### 오늘 스냅샷
| 항목 | 수치 |
|------|------|
| 세션 수 | N개 |
| 총 프롬프트 | N개 |
| 재시도율 | N% |
| 서브에이전트 활용 | N회 |
| /compact 사용 | N회 |

### 잘 쓴 점
- (데이터 기반 구체적 칭찬 1~2개)

### 개선 포인트
1. **(가장 임팩트 큰 것)** - 구체적 상황 + 대안
2. **(두 번째)** - 구체적 상황 + 대안
3. **(세 번째)** - 구체적 상황 + 대안

### 내일 시도해볼 것
> (가장 쉽게 적용할 수 있는 한 가지)
```

## 규칙
- `/daily-review`와 차이: 거기는 시간/비용 분석, 여기는 **활용법 개선**에 집중
- 데이터 없으면 추측하지 말고 "데이터 부족" 안내
- 개선점은 최대 3개. 핵심만
- "~하면 좋겠습니다" 대신 "~해보세요" 톤
- 매번 같은 뻔한 조언 금지. 오늘 실제 데이터에서 나온 것만
