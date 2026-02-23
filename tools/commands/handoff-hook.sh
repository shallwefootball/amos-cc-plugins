#!/bin/bash
if [ -f .handoff/latest.md ]; then
  SIZE=$(wc -c < .handoff/latest.md)
  echo "<handoff-context>"
  echo "이전 세션 작업 상태. 핵심 파일은 직접 Read하세요."
  echo ""
  if [ "$SIZE" -gt 8000 ]; then
    head -c 8000 .handoff/latest.md
    echo ""
    echo "... (truncated, full: .handoff/latest.md)"
  else
    cat .handoff/latest.md
  fi
  echo "</handoff-context>"
fi
