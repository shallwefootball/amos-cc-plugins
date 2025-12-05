---
description: GitHub 레포지토리를 클론하고 구조를 분석하여 마크다운 문서로 정리합니다
---

GitHub 레포지토리를 분석하는 작업을 수행합니다.

**언어: 분석 내용은 한국어를 기본으로 하되, 기술 용어나 번역이 어색한 표현은 영어를 사용해도 됩니다.**

**실행 모드:**
- **모드 1: URL 제공 시** - `/analyze-repo https://github.com/owner/repo`
- **모드 2: URL 없이 실행** - `/analyze-repo` (현재 디렉토리가 git 레포인 경우)

## 실행 단계

### 1. 스크립트 실행

먼저 데이터 수집 스크립트를 실행합니다:

```bash
bash "$PLUGIN_DIR/scripts/analyze.sh" [GitHub-URL-if-provided]
```

스크립트는 다음을 수행합니다:
- git clone (모드 1) 또는 현재 디렉토리 사용 (모드 2)
- GitHub 메타데이터 수집 (stars, forks, license, description, last commit)
- 디렉토리 구조 수집 (tree 명령)
- 기술 스택 파일 탐지

스크립트는 JSON 형태로 결과를 반환합니다.

### 2. 스크립트 결과 처리

**스크립트 결과가 `"status": "exists"`인 경우:**
- 레포지토리가 이미 존재함
- 사용자에게 물어보기: "디렉토리가 이미 존재합니다. 1) 기존 것을 분석, 2) 삭제 후 새로 클론"
- 사용자 선택에 따라:
  - 기존 것 분석: 해당 경로에서 분석 진행
  - 새로 클론: `rm -rf [repo_path] && bash "$PLUGIN_DIR/scripts/analyze.sh" [url]` 실행

**스크립트 결과가 `"status": "success"`인 경우:**
- JSON에서 다음 정보 추출:
  - `repo_path`: 분석 대상 경로
  - `repo_name`: 레포지토리 이름
  - `metadata`: 메타데이터 (url, description, stars, forks, license, last_commit)
  - `structure`: 디렉토리 구조
  - `tech_stack_files`: 기술 스택 파일 존재 여부

### 3. 코드베이스 탐색 및 분석

스크립트가 수집한 기본 정보를 바탕으로, Task 도구의 Explore agent를 사용하여 심층 분석을 수행합니다:

```
Task tool with subagent_type='Explore', thoroughness='very thorough'
```

다음 사항을 집중적으로 탐색:
- 프로젝트의 핵심 목적과 기능
- 주요 진입점 (main, index, app 등)
- 아키텍처 패턴 (MVC, microservices, monorepo 등)
- API 엔드포인트 및 라우팅
- 데이터베이스 모델/스키마
- 주요 의존성의 사용 목적
- 설정 파일 및 환경 변수

### 4. REPO-ANALYSIS.md 생성

`repo_path`에 `REPO-ANALYSIS.md` 파일을 생성합니다. 스크립트에서 수집한 데이터와 Explore agent의 분석 결과를 종합하여 작성합니다:

```markdown
# [레포지토리 이름] 분석

## 레포지토리 정보
- **GitHub URL**: [metadata.url]
- **설명**: [metadata.description]
- **Stars**: ⭐ [metadata.stars]
- **Forks**: 🍴 [metadata.forks]
- **라이선스**: [metadata.license]
- **마지막 커밋**: 📅 [metadata.last_commit]

## 개요
[프로젝트가 무엇을 하는지 2-3 문장으로 설명]

## 기술 스택
- **언어**: [주요 프로그래밍 언어]
- **프레임워크**: [주요 프레임워크]
- **주요 라이브러리**: [핵심 의존성 3-5개]

## 프로젝트 구조
```
[structure 데이터 사용]
```

**주요 디렉토리:**
- `src/` - [설명]
- `tests/` - [설명]
- ... [기타 중요 디렉토리]

## 핵심 컴포넌트
[주요 파일과 모듈을 나열하고 각각의 역할 설명]
- `path/to/file.ext` - [역할]

## 의존성
**주요 의존성 분석:**
- `library-name` - [사용 목적과 역할]

## 아키텍처
[아키텍처 패턴, 설계 철학, 데이터 흐름 설명]

## 진입점
**실행 방법:**
```bash
[실제 실행 명령어]
```

**주요 진입점 파일:**
- [진입점 파일 경로와 설명]

## 추가 메모
[분석 중 발견한 특이사항, 주의할 점 등]
```

### 5. 최종 결과 출력

사용자에게 다음 정보를 제공:
- 분석한 레포지토리 경로: `[repo_path]`
- 분석 파일 위치: `[repo_path]/REPO-ANALYSIS.md`
- 간단한 요약 (2-3줄)

## 중요 사항

- **스크립트 우선**: 데이터 수집은 스크립트가 처리. LLM은 분석과 문서 작성에 집중
- **Explore agent 활용**: 코드베이스 이해는 반드시 Explore agent 사용
- **JSON 파싱**: 스크립트 결과를 정확히 파싱하여 사용
- **에러 처리**: 스크립트 실행 실패 시 사용자에게 명확한 에러 메시지 제공
