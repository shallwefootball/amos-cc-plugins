# cc-toolkit

Claude Code 유틸리티 모음.

## 설치

```bash
# 마켓플레이스 추가
/plugin marketplace add shallwefootball/cc-toolkit

# 플러그인 설치
/plugin install tools@cc-toolkit
```

## 커맨드

| 커맨드 | 설명 |
|--------|------|
| `/today` | 오늘 Claude Code 활동 요약 |
| `/yesterday` | 어제 Claude Code 활동 요약 |
| `/capture` | 대화 내용을 Obsidian에 저장 |
| `/intellij` | IntelliJ IDEA CE에서 열기 |
| `/update` | 마켓플레이스 업데이트 |
| `/sync` | 코드-문서 동기화 (light) |
| `/sync-full` | 코드-문서 동기화 (full) |

### /today, /yesterday

Claude Code 활동 요약을 보여줍니다.
- timestamp 기반 정확한 세션 추출
- 프로젝트별 프롬프트 수 집계
- 세션별 요약 정보

### /capture

대화 내용을 Obsidian 볼트에 저장합니다.
- 저장 경로 선택/저장 (`~/.claude/capture-paths.json`)
- 자동 제목 생성
- Git 정보 포함 (branch, commit)

### /intellij

현재 디렉토리를 IntelliJ IDEA CE에서 엽니다.

### /update

cc-toolkit 마켓플레이스를 GitHub에서 최신 버전으로 업데이트합니다.

### /sync, /sync-full

코드와 문서를 동기화합니다.
- `/sync` (light): 현재 대화 맥락 기반
- `/sync-full` (full): git diff 기반 꼼꼼한 체크

## 업데이트

```bash
/update
```

## License

MIT

---

Made with Claude Code
