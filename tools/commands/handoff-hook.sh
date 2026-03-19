#!/bin/bash
if [ -f .handoff/latest.md ]; then
  LINES=$(wc -l < .handoff/latest.md 2>/dev/null || echo 0)
  SIZE=$(wc -c < .handoff/latest.md 2>/dev/null || echo 0)

  if [ "$SIZE" -gt 8000 ]; then
    CONTENT=$(head -c 8000 .handoff/latest.md)
    CONTENT="${CONTENT}\n... (truncated, full: .handoff/latest.md)"
  else
    CONTENT=$(cat .handoff/latest.md)
  fi

  # JSON escape via python3
  ESCAPED=$(echo "$CONTENT" | python3 -c 'import sys,json; print(json.dumps(sys.stdin.read()))')

  # systemMessage → 사용자 터미널에 표시
  # additionalContext → Claude 컨텍스트에 주입
  cat <<ENDJSON
{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":${ESCAPED}},"systemMessage":"📋 handoff loaded (${LINES} lines, ${SIZE} bytes)"}
ENDJSON
fi
exit 0
