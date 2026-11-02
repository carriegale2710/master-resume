#!/usr/bin/env bash
# PreToolUse hook: refuse any tool call that names the secret .env or ~/.config/resume.
# Reads the tool-call JSON on stdin; exit 2 blocks the call and shows stderr to the agent.
# Allows .env.example, .environment and similar (".env" must end the name).
# ponytail: text match on the whole payload, so a disguised path like `cat $(echo .e)nv` slips past; use a sandbox or a separate user for a hard guarantee.
in="$(cat)"
if grep -Eq '(^|[^A-Za-z0-9_])\.env([^.A-Za-z0-9_-]|$)|\.config/resume' <<<"$in"; then
  echo "Blocked: secret file" >&2
  exit 2
fi
