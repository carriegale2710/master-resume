#!/usr/bin/env bash
set -euo pipefail
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
t="$(mktemp)"; trap 'rm -f "$t"' EXIT
export TRACKER="$t"
fail() { echo "FAIL: $1" >&2; exit 1; }
printf 'id,date_applied,company,role,location,source,version_folder,status,last_update,contact,outcome,notes,opening_date,closing_date\n2026-10-acme-dev,,Acme,Dev,Remote,seek,2026-10-acme-dev,pending,2026-10-01,,,,,\n2026-10-beta-dev,,Beta,Dev,Remote,seek,2026-10-beta-dev,pending,2026-10-01,,,,,\n' > "$t"
bash "$repo_root/scripts/ready.sh" applications/2026-10-acme-dev >/dev/null
grep -q '^2026-10-acme-dev,.*,ready,' "$t" || fail "ready.sh did not mark row"
bash "$repo_root/scripts/set-status.sh" 2026-10-acme-dev exported >/dev/null
grep -q '^2026-10-acme-dev,.*,exported,' "$t" || fail "set-status did not mark exported"
grep -q ',pending,2026-10-01,' <(sed -n 3p "$t") || fail "other row changed"
bash "$repo_root/scripts/set-status.sh" nope ready >/dev/null 2>&1 && fail "missing row accepted"
bash "$repo_root/scripts/set-status.sh" 2026-10-acme-dev bogus >/dev/null 2>&1 && fail "bad status accepted"
echo "PASS: set-status.sh/ready.sh update only the matching row"
