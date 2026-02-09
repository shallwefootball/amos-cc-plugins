#!/bin/bash
# commit-guard: blocks direct git commit, redirects to /amos:commit skill
#
# Allows git commit if /tmp/.amos-commit-active marker file exists.
# The /amos:commit skill creates this file as its first step.

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Allow if marker file exists (commit skill is active)
if [ -f /tmp/.amos-commit-active ]; then
  exit 0
fi

if echo "$COMMAND" | grep -qE '(^|\s|&&|\|\||;)git\s+commit(\s|$)'; then
  cat <<'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "Direct git commit is blocked. Use /commit skill instead."
  }
}
EOF
fi
