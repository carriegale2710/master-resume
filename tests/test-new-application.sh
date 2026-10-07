#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

fail() {
  echo "FAIL: $1" >&2
  exit 1
}

year_month="$(date +%Y-%m)"
application_dir="$tmp_dir/applications/$year_month-synthetic-example"

(
  cd "$tmp_dir"
  bash "$repo_root/scripts/new-application.sh" synthetic-example
) || fail "new-application.sh did not create the application"

[[ -f "$application_dir/job-description.md" ]] || fail "Missing job-description.md"
[[ -f "$application_dir/notes.md" ]] || fail "Missing notes.md"
[[ -f "$application_dir/cover-letter.md" ]] || fail "Missing cover-letter.md"
[[ ! -s "$application_dir/cover-letter.md" ]] || fail "cover-letter.md should be empty"
grep -q '^# Job description$' "$application_dir/job-description.md" || fail "Unexpected job-description.md template"
grep -q '^# Notes$' "$application_dir/notes.md" || fail "Unexpected notes.md template"

if (
  cd "$tmp_dir"
  bash "$repo_root/scripts/new-application.sh" synthetic-example >/dev/null 2>&1
); then
  fail "Duplicate application creation should fail"
fi

echo "PASS: new-application.sh creates expected files and rejects duplicates"
