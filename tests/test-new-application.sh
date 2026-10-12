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

for safe_name in Acme-42 7Role a; do
  (
    cd "$tmp_dir"
    bash "$repo_root/scripts/new-application.sh" "$safe_name" >/dev/null
  ) || fail "Safe application name should be accepted: $safe_name"
  [[ -d "$tmp_dir/applications/$year_month-$safe_name" ]] ||
    fail "Safe application name should create a directory: $safe_name"
done

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

for invalid_name in '' '../outside' 'company/role' 'company/../role' 'company\role' '..' '.' '-company' 'company-' 'company_role' 'company role' 'café'; do
  if (
    cd "$tmp_dir"
    bash "$repo_root/scripts/new-application.sh" "$invalid_name" >/dev/null 2>&1
  ); then
    fail "Invalid application name should be rejected: $invalid_name"
  fi
done

[[ ! -e "$tmp_dir/outside" ]] || fail "Invalid application name created a path outside applications"

fake_bin="$tmp_dir/fake-bin"
mkdir -p "$fake_bin"
printf '#!/usr/bin/env bash\nprintf "../outside-month\\n"\n' > "$fake_bin/date"
chmod +x "$fake_bin/date"
if (
  cd "$tmp_dir"
  PATH="$fake_bin:$PATH" bash "$repo_root/scripts/new-application.sh" containment-escape >/dev/null 2>&1
); then
  fail "Application target resolving outside applications should be rejected"
fi
[[ ! -e "$tmp_dir/outside-month-containment-escape" ]] || fail "Created application directory outside applications"

outside_target="$tmp_dir/outside-target"
mkdir -p "$outside_target"
ln -s "$outside_target" "$tmp_dir/applications/$year_month-symlink-escape"
if (
  cd "$tmp_dir"
  bash "$repo_root/scripts/new-application.sh" symlink-escape >/dev/null 2>&1
); then
  fail "Application target resolving outside applications should be rejected"
fi
[[ ! -e "$outside_target/job-description.md" ]] || fail "Created application files outside applications"

if (
  cd "$tmp_dir"
  bash "$repo_root/scripts/new-application.sh" synthetic-example >/dev/null 2>&1
); then
  fail "Duplicate application creation should fail"
fi

echo "PASS: new-application.sh creates expected files and rejects duplicates"
