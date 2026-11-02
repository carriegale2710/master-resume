#!/usr/bin/env bash
set -euo pipefail
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
hook="$repo_root/.claude/hooks/block-secrets.sh"
fail() { echo "FAIL: $1" >&2; exit 1; }

# run_hook <tool_name> <tool_input_json>: prints the hook's exit code, as Claude Code would send the payload.
run_hook() {
  local rc=0
  printf '{"session_id":"s","cwd":"/work/master-resume","hook_event_name":"PreToolUse","tool_name":"%s","tool_input":%s}' "$1" "$2" \
    | bash "$hook" >/dev/null 2>&1 || rc=$?
  echo "$rc"
}
blocked() { [ "$(run_hook "$1" "$2")" = 2 ] || fail "expected block: $1 $2"; }
allowed() { [ "$(run_hook "$1" "$2")" = 0 ] || fail "expected allow: $1 $2"; }

blocked Bash '{"command":"cat .env"}'
blocked Bash '{"command":"cat .env\n"}'
blocked Bash '{"command":"source ./.env; echo $RESUME_NAME"}'
blocked Bash '{"command":"head -1 \".env\""}'
blocked Bash '{"command":"cat ~/.config/resume/identity.env"}'
blocked Read '{"file_path":"/work/master-resume/.env"}'
blocked Grep '{"pattern":"RESUME","path":".env"}'
blocked Glob '{"pattern":"**/.env"}'

allowed Bash '{"command":"git status"}'
allowed Bash '{"command":"env"}'
allowed Bash '{"command":"bash scripts/build.sh --md-only master/master-resume.md"}'
allowed Read '{"file_path":"/work/master-resume/.env.example"}'
allowed Read '{"file_path":"/work/master-resume/docs/dotenv.md"}'
allowed Glob '{"pattern":"**/*.environment"}'

msg="$(printf '{"tool_input":{"command":"cat .env"}}' | bash "$hook" 2>&1 >/dev/null || true)"
[[ "$msg" == *"Blocked: secret file"* ]] || fail "missing block message on stderr"

settings="$repo_root/.claude/settings.json"
grep -q '"PreToolUse"' "$settings" || fail "settings.json does not register a PreToolUse hook"
grep -q 'hooks/block-secrets.sh' "$settings" || fail "settings.json does not run block-secrets.sh"
grep -q '"Bash|Read|Grep|Glob"' "$settings" || fail "hook matcher missing Bash|Read|Grep|Glob"

echo "PASS: block-secrets.sh blocks .env and ~/.config/resume, allows look-alikes, and is registered"
