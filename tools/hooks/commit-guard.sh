#!/bin/bash
# commit-guard: blocks direct git commit, redirects to /amos:commit skill
#
# PreToolUse hook for Bash tool.
# Reads tool_input from stdin JSON, checks if command contains "git commit".
# If so, denies execution and tells Claude to use the commit skill instead.

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

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
