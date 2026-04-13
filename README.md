# cc-toolkit

Claude Code 유틸리티 + 에이전트 팩.

## 설치

```bash
# 마켓플레이스 추가
/plugin marketplace add shallwefootball/cc-toolkit

# 플러그인 설치
/plugin install tools@cc-toolkit
```

## 스킬 (18개)

### 활동 분석

| 커맨드 | 설명 |
|--------|------|
| `/today` | 오늘 Claude Code 활동 요약 |
| `/yesterday` | 어제 Claude Code 활동 요약 |
| `/cc-coach` | 현재 세션 상태 진단 + CC 활용 팁 |
| `/cc-review` | 오늘 CC 사용 패턴 분석 + 개선점 |

### 세션 관리

| 커맨드 | 설명 |
|--------|------|
| `/handoff` | 작업 상태를 `.handoff/`에 저장 (새 세션 자동 주입) |
| `/handoff-init` | handoff 시스템 설치 (hook + gitignore) |
| `/handoff-draft` | handoff 초안을 터미널에 출력 (다른 세션 전달용) |
| `/handoff-inject` | 받은 handoff를 프로젝트에 주입 |
| `/checkpoint` | `.handoff/` 체크포인트 저장 (`/compact` 전에 사용) |

### 개발 도구

| 커맨드 | 설명 |
|--------|------|
| `/commit` | 변경사항을 의미 단위로 쪼개 커밋 |
| `/dive` | 주제를 번호 기반 목차로 정리, 서브에이전트로 탐구 |
| `/recap` | 세션 작업 여정을 프로젝트 docs/에 기록 |
| `/ddd-init` | DDD 에이전트 3종 프로젝트에 설치 |
| `/intellij` | IntelliJ IDEA CE에서 열기 (macOS/Linux) |

### 문서 / 기타

| 커맨드 | 설명 |
|--------|------|
| `/sync` | 코드-문서 동기화 (light) |
| `/sync-full` | 코드-문서 동기화 (full) |
| `/capture` | 대화 내용을 Obsidian에 저장 |
| `/update` | 마켓플레이스 업데이트 |

## 에이전트 (18개)

### ddd — 도메인 주도 설계

| 에이전트 | 설명 |
|----------|------|
| `analyst` | DDD 설계 문서 작성 (6단계 프로세스) |
| `coder` | DDD 설계 문서 기반 코드 구현 |
| `scout` | 코드베이스를 PM 관점 비즈니스 리포트로 |

### quality — 코드 품질

| 에이전트 | 설명 |
|----------|------|
| `reviewer` | PR/diff/파일 코드 리뷰 |
| `tester` | 테스트 작성, 커버리지 분석 |
| `security` | 보안 취약점 감사 |
| `debugger` | 런타임 버그 추적, 근본 원인 분석 |
| `architect-reviewer` | 시스템 아키텍처 레벨 리뷰 |

### maintain — 유지보수

| 에이전트 | 설명 |
|----------|------|
| `refactor-planner` | 대규모 리팩토링 실행 계획 |
| `migration` | 라이브러리/프레임워크 업그레이드 가이드 |
| `tech-debt` | 기술 부채 식별 + 우선순위 |

### dx — 개발자 경험

| 에이전트 | 설명 |
|----------|------|
| `perf` | 성능 병목 분석 + 최적화 제안 |
| `docs-weaver` | 문서 생성/동기화/감사 (README, API, CHANGELOG) |

### dev — 개발

| 에이전트 | 설명 |
|----------|------|
| `app` | 범용 애플리케이션 개발 |
| `ui-craftsman` | "AI 안 만든 것 같은" UI 생성/다듬기 |

### data — 데이터

| 에이전트 | 설명 |
|----------|------|
| `db-architect` | DB 스키마 설계, 쿼리 최적화 |
| `ai-engineer` | RAG, 벡터 DB, AI 에이전트 구축 |

### ops — 운영

| 에이전트 | 설명 |
|----------|------|
| `troubleshooter` | 프로덕션 인시던트, 인프라 이슈 진단 |

## 업데이트

```bash
/update
```

## License

MIT

---

Made with Claude Code
