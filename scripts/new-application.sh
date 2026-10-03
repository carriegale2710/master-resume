#!/usr/bin/env bash
# Usage: ./scripts/new-application.sh company-role
set -euo pipefail
[ $# -eq 1 ] || { echo "Usage: $0 company-role"; exit 1; }
dir="applications/$(date +%Y-%m)-$1"
[ -e "$dir" ] && { echo "Already exists: $dir"; exit 1; }
mkdir -p "$dir"
printf '# Job description\n\nURL:\nDate posted:\n\n(paste posting here)\n' > "$dir/job-description.md"
printf '# Notes\n\nContacts:\nInterview prep:\nOutcome:\n' > "$dir/notes.md"
: > "$dir/cover-letter.md"
echo "Created $dir"
echo "Next: ./scripts/build.sh --tags frontend,a11y --md-only master/master-resume.md > $dir/resume.md"
