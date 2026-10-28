#!/usr/bin/env bash
# Usage: ./scripts/new-application.sh company-role
set -euo pipefail
[ $# -eq 1 ] || { echo "Usage: $0 company-role"; exit 1; }
name="$1"
[[ "$name" =~ ^[A-Za-z0-9]+([A-Za-z0-9-]*[A-Za-z0-9])?$ ]] || {
  echo "Invalid application name: use ASCII letters, numbers, and hyphens; start and end with a letter or number." >&2
  exit 1
}

dir="applications/$(date +%Y-%m)-$name"
if [ -e "$dir" ]; then
  echo "Already exists: $dir"
  exit 1
fi
mkdir -p "$dir"
printf '# Job description\n\nURL:\nDate posted:\nClosing date:\n\n(paste posting here)\n' > "$dir/job-description.md"
printf '# Notes\n\nContacts:\nInterview prep:\nOutcome:\n' > "$dir/notes.md"
: > "$dir/cover-letter.md"
tracker=applications/tracker.csv
[ -f "$tracker" ] || echo "id,date_applied,company,role,location,source,version_folder,status,last_update,contact,outcome,notes,opening_date,closing_date,eligibility" > "$tracker"
id="$(basename "$dir")"
echo "$id,,$name,,,,$id,pending,$(date +%F),,,,,," >> "$tracker"
echo "Created $dir (tracker row: pending)"
echo "Next: Copy in the job description and run ./scripts/build.sh --tags <tag1,tag2> --md-only master/master-resume.md > $dir/resume.md"
