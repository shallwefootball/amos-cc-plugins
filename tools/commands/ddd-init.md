---
description: 현재 프로젝트에 DDD 에이전트(analyst, coder)를 설치합니다
allowed-tools: Bash(mkdir:*), Bash(cp:*), Bash(ls:*), Read, Write
---

현재 프로젝트에 DDD 에이전트를 설치합니다.

## 실행

1. `.claude/agents/` 디렉토리를 생성합니다.
2. cc-toolkit의 DDD 에이전트 소스를 현재 프로젝트에 복사합니다.

```bash
mkdir -p .claude/agents
```

다음 파일들을 `~/.claude/plugins/marketplaces/cc-toolkit/tools/agents/ddd/` 에서 읽어서 `.claude/agents/`에 Write 도구로 작성하세요:

- `ddd-analyst.md` → `.claude/agents/ddd-analyst.md`
- `ddd-coder.md` → `.claude/agents/ddd-coder.md`

## 완료 후

설치 결과를 보여주세요:

```
DDD 에이전트 설치 완료!

설치된 에이전트:
- ddd-analyst: DDD 설계/분석 (설계 문서 작성)
- ddd-coder: DDD 구현 (체크리스트 기반 코딩)

사용법:
1. ddd-analyst에게 설계를 요청하세요
2. 설계 완료 후 ddd-coder에게 구현을 맡기세요
```
