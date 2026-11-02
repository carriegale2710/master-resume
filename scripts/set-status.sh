#!/usr/bin/env bash
# Usage: ./scripts/set-status.sh <application-folder> <status> [cover]
# Sets status and last_update (today) on the applications/tracker.csv row whose id equals the folder name.
# Statuses: pending tailored verified ready exported. With "cover" it sets cover_letter_status instead
# (none drafted verified exported) and leaves status alone. Columns are found by header name.
# Override the file with TRACKER. ponytail: plain comma split, so quoted commas in a row shift fields; use a CSV tool if that happens.
set -euo pipefail
{ [ $# -eq 2 ] || { [ $# -eq 3 ] && [ "$3" = cover ]; }; } || { echo "Usage: $0 <application-folder> <status> [cover]" >&2; exit 1; }
col=status
if [ $# -eq 3 ]; then
  col=cover_letter_status
  case "$2" in none|drafted|verified|exported) ;; *) echo "Unknown cover letter status: $2" >&2; exit 1 ;; esac
else
  case "$2" in pending|tailored|verified|ready|exported) ;; *) echo "Unknown status: $2" >&2; exit 1 ;; esac
fi
f="${TRACKER:-$(dirname "$0")/../applications/tracker.csv}"
key="$(basename "$1")"
tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT
awk -F, -v OFS=, -v k="$key" -v s="$2" -v col="$col" -v d="$(date +%F)" '
  NR==1 { for (i=1;i<=NF;i++) c[$i]=i; bad = !(c["id"] && c[col] && c["last_update"]); print; next }
  !bad && $(c["id"])==k { $(c[col])=s; $(c["last_update"])=d; n++ }
  { print }
  END { exit (bad || !n) }' "$f" > "$tmp" ||
  { echo "No tracker row with id=$key (or tracker lacks id/$col/last_update columns)" >&2; exit 1; }
cat "$tmp" > "$f"
if [ "$col" = status ]; then echo "Status $2: $key"; else echo "Cover letter $2: $key"; fi
