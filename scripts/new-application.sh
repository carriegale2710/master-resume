#!/usr/bin/env bash
# Usage: ./scripts/new-application.sh company-role
set -euo pipefail
[ $# -eq 1 ] || { echo "Usage: $0 company-role"; exit 1; }
name="$1"
[[ "$name" =~ ^[A-Za-z0-9]+([A-Za-z0-9-]*[A-Za-z0-9])?$ ]] || {
  echo "Invalid application name: use ASCII letters, numbers, and hyphens; start and end with a letter or number." >&2
  exit 1
}

mkdir -p applications
applications_root="$(cd applications && pwd -P)"
dir="$applications_root/$(date +%Y-%m)-$name"
if [ -e "$dir" ] || [ -L "$dir" ]; then
  echo "Already exists: $dir"
  exit 1
fi
target_parent="$(cd "$(dirname "$dir")" && pwd -P)"
canonical_target="$target_parent/$(basename "$dir")"
case "$canonical_target" in
  "$applications_root"/*) ;;
  *)
    echo "Application path escapes applications/: $canonical_target" >&2
    exit 1
    ;;
esac
mkdir "$dir"
printf '# Job description\n\nURL:\nDate posted:\n\n(paste posting here)\n' > "$dir/job-description.md"
printf '# Notes\n\nContacts:\nInterview prep:\nOutcome:\n' > "$dir/notes.md"
: > "$dir/cover-letter.md"
echo "Created $dir"
echo "Next: ./scripts/build.sh --tags frontend,a11y --md-only master/master-resume.md > $dir/resume.md"
