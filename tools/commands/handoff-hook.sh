#!/bin/bash
if [ -f .handoff/latest.md ]; then
  echo "<handoff-context>"
  cat .handoff/latest.md
  echo "</handoff-context>"
fi
