#!/bin/bash
# commit-guard: blocks direct git commit, redirects to /amos:commit skill
#
# PreToolUse hook for Bash tool.
# Blocks "git commit" unless prefixed with AMOS_COMMIT=1 (from /amos:commit skill).

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Allow commits from /amos:commit skill (marked with AMOS_COMMIT=1)
if echo "$COMMAND" | grep -q "AMOS_COMMIT=1"; then
  exit 0
fi

if echo "$COMMAND" | grep -qE '(^|\s|&&|\|\||;)git\s+commit(\s|$)'; then
  cat <<'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "Direct git commit is blocked. Use /amos:commit skill instead."
  }
}
EOF
fi
