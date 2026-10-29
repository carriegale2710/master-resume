#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fixture="$repo_root/tests/fixtures/dummy-resume.md"

fail() {
  echo "FAIL: $1" >&2
  exit 1
}

contains() {
  [[ "$1" == *"$2"* ]] || fail "Expected output to contain: $2"
}

omits() {
  [[ "$1" != *"$2"* ]] || fail "Expected output to omit: $2"
}

filtered="$(bash "$repo_root/scripts/build.sh" --tags frontend,qa --md-only "$fixture")"
contains "$filtered" "Synthetic untagged summary text."
contains "$filtered" "Built a synthetic interface."
contains "$filtered" "Synthetic frontend detail."
contains "$filtered" "Checked a synthetic workflow."
contains "$filtered" "Synthetic public section text."
omits "$filtered" "Built a synthetic service."
omits "$filtered" "PRIVATE_SENTINEL"
omits "$filtered" "Synthetic editorial note"
omits "$filtered" "Tag key"
omits "$filtered" "Variant key"
omits "$filtered" '`frontend`'
omits "$filtered" '`qa`'

all_tags="$(bash "$repo_root/scripts/build.sh" --md-only "$fixture")"
contains "$all_tags" "Built a synthetic interface."
contains "$all_tags" "Built a synthetic service."
contains "$all_tags" "Checked a synthetic workflow."
omits "$all_tags" "PRIVATE_SENTINEL"

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

# Docx builds need a verified tracker row: use a throwaway tracker, reset before each build, approve with y.
export TRACKER="$tmp_dir/tracker.csv"
docx_build() {
  printf 'id,status,last_update\n%s,verified,\n' "$(basename "$(dirname "$(realpath "${@: -1}")")")" > "$TRACKER"
  bash "$repo_root/scripts/build.sh" "$@" <<< y
}

mock_bin="$tmp_dir/bin"
mkdir -p "$mock_bin"
cat << 'EOF' > "$mock_bin/pandoc"
#!/usr/bin/env bash
cat > /dev/null
EOF
chmod +x "$mock_bin/pandoc"

large_todo="$tmp_dir/large-todo.md"
{
  echo "# Large Resume"
  echo ""
  echo "- TODO: synthetic placeholder item"
  for i in {1..2000}; do
    echo "- Section item $i with long descriptive text to exceed the standard pipe buffer"
  done
} > "$large_todo"

todo_err="$(PATH="$mock_bin:$PATH" docx_build "$large_todo" 2>&1 >/dev/null)"
contains "$todo_err" "WARNING: TODO placeholders remain in output:"
contains "$todo_err" "3:- TODO: synthetic placeholder item"

clean_resume="$tmp_dir/clean-resume.md"
{
  echo "# Clean Resume"
  echo ""
  echo "- Fully resolved synthetic item"
  for i in {1..2000}; do
    echo "- Section item $i with long descriptive text to exceed the standard pipe buffer"
  done
} > "$clean_resume"

clean_err="$(PATH="$mock_bin:$PATH" docx_build "$clean_resume" 2>&1 >/dev/null)"
omits "$clean_err" "WARNING: TODO placeholders remain in output:"
omits "$clean_err" "TODO"

for section in 6 7 8 9 10; do
  private_boundary="$tmp_dir/private-section-$section.md"
  cat > "$private_boundary" <<EOF
# Synthetic boundary test

Public text before private section $section.

## $section. Synthetic Private Section

PRIVATE_BOUNDARY_SENTINEL_$section
EOF
  boundary_output="$(bash "$repo_root/scripts/build.sh" --md-only "$private_boundary")"
  contains "$boundary_output" "Public text before private section $section."
  omits "$boundary_output" "PRIVATE_BOUNDARY_SENTINEL_$section"
done

tagged_todo="$tmp_dir/tagged-todo.md"
{
  echo "# Tagged Resume"
  echo ""
  echo "- \`qa\` TODO: qa item"
  echo "- \`frontend\` Clean frontend bullet"
} > "$tagged_todo"

filtered_todo_err="$(PATH="$mock_bin:$PATH" docx_build --tags frontend "$tagged_todo" 2>&1 >/dev/null)"
omits "$filtered_todo_err" "WARNING: TODO placeholders remain in output:"

tagged_todo_err="$(PATH="$mock_bin:$PATH" docx_build --tags qa "$tagged_todo" 2>&1 >/dev/null)"
contains "$tagged_todo_err" "WARNING: TODO placeholders remain in output:"
contains "$tagged_todo_err" "TODO: qa item"

capture_bin="$tmp_dir/capture-bin"
mkdir -p "$capture_bin"
cat << 'EOF' > "$capture_bin/pandoc"
#!/usr/bin/env bash
cat > "$PANDOC_CAPTURE"
EOF
chmod +x "$capture_bin/pandoc"

header_resume="$tmp_dir/header-resume.md"
printf '# ${RESUME_NAME}\n${RESUME_LOCATION} | ${RESUME_WORKRIGHTS} | ${RESUME_EMAIL} | ${RESUME_PHONE} | ${RESUME_LINKS}\nSaved $5 for ${RESUME_NAME}\n' > "$header_resume"

env_file="$tmp_dir/test.env"
cat > "$env_file" <<'EOF'
RESUME_NAME="Test & Name \ Synthetic"
RESUME_EMAIL="test@example.invalid"
RESUME_LOCATION="Testville, NSW"
RESUME_WORKRIGHTS="Test work rights"
RESUME_PHONE="0400 000 000"
RESUME_LINKS="example.invalid/test"
EOF

export PANDOC_CAPTURE="$tmp_dir/captured.md"
RESUME_ENV_FILE="$env_file" PATH="$capture_bin:$PATH" docx_build "$header_resume" >/dev/null
captured="$(<"$PANDOC_CAPTURE")"
contains "$captured" 'Test & Name \ Synthetic'
contains "$captured" "Testville, NSW | Test work rights | test@example.invalid | 0400 000 000 | example.invalid/test"
contains "$captured" 'Saved $5 for Test & Name \ Synthetic'
omits "$captured" 'RESUME_'

header_md="$(RESUME_ENV_FILE="$tmp_dir/does-not-exist.env" bash "$repo_root/scripts/build.sh" --md-only "$header_resume")"
contains "$header_md" '${RESUME_EMAIL}'
omits "$header_md" "test@example.invalid"

grep -v '^RESUME_EMAIL=' "$env_file" > "$tmp_dir/partial.env"
missing_err="$(RESUME_ENV_FILE="$tmp_dir/partial.env" PATH="$capture_bin:$PATH" docx_build "$header_resume" 2>&1 >/dev/null)" && fail "Expected build to fail when RESUME_EMAIL is unset"
contains "$missing_err" "Missing RESUME_EMAIL"

grep -v '^RESUME_WORKRIGHTS=' "$env_file" > "$tmp_dir/partial2.env"
wr_err="$(RESUME_ENV_FILE="$tmp_dir/partial2.env" PATH="$capture_bin:$PATH" docx_build "$header_resume" 2>&1 >/dev/null)" && fail "Expected build to fail when RESUME_WORKRIGHTS is unset"
contains "$wr_err" "Missing RESUME_WORKRIGHTS"

nofile_err="$(RESUME_ENV_FILE="$tmp_dir/does-not-exist.env" PATH="$capture_bin:$PATH" docx_build "$header_resume" 2>&1 >/dev/null)" && fail "Expected build to fail when .env is missing"
contains "$nofile_err" "Missing $tmp_dir/does-not-exist.env"

sub_bullet="$tmp_dir/sub-bullet.md"
{
  echo "# Sub-bullet Resume"
  echo ""
  echo "- \`backend\` Excluded bullet"
  echo "  - EXCLUDED_SUB_SENTINEL"
  echo "- \`frontend\` Kept bullet"
  echo "  - KEPT_SUB_SENTINEL"
} > "$sub_bullet"
sub_out="$(bash "$repo_root/scripts/build.sh" --tags frontend --md-only "$sub_bullet")"
contains "$sub_out" "KEPT_SUB_SENTINEL"
omits "$sub_out" "EXCLUDED_SUB_SENTINEL"

trailing_tag="$tmp_dir/trailing-tag.md"
printf '%s\n' "# Trailing Tag Resume" "" '- Built a thing `frontend`' > "$trailing_tag"
trailing_out="$(bash "$repo_root/scripts/build.sh" --tags frontend --md-only "$trailing_tag")"
contains "$trailing_out" "Built a thing"
omits "$trailing_out" '`frontend`'

new_tags="$tmp_dir/new-tags.md"
printf '%s\n' "# New Tag Resume" "" '- `research` `customer-service` Ran a synthetic survey.' > "$new_tags"
new_tags_out="$(bash "$repo_root/scripts/build.sh" --tags research --md-only "$new_tags")"
contains "$new_tags_out" "- Ran a synthetic survey."
omits "$new_tags_out" '`'

echo "PASS: build.sh filters tags, removes private metadata, warns on TODO placeholders, and fills the private header from .env"
