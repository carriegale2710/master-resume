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

todo_err="$(PATH="$mock_bin:$PATH" bash "$repo_root/scripts/build.sh" "$large_todo" 2>&1 >/dev/null)"
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

clean_err="$(PATH="$mock_bin:$PATH" bash "$repo_root/scripts/build.sh" "$clean_resume" 2>&1 >/dev/null)"
omits "$clean_err" "WARNING: TODO placeholders remain in output:"
omits "$clean_err" "TODO"

tagged_todo="$tmp_dir/tagged-todo.md"
{
  echo "# Tagged Resume"
  echo ""
  echo "- \`qa\` TODO: qa item"
  echo "- \`frontend\` Clean frontend bullet"
} > "$tagged_todo"

filtered_todo_err="$(PATH="$mock_bin:$PATH" bash "$repo_root/scripts/build.sh" --tags frontend "$tagged_todo" 2>&1 >/dev/null)"
omits "$filtered_todo_err" "WARNING: TODO placeholders remain in output:"

tagged_todo_err="$(PATH="$mock_bin:$PATH" bash "$repo_root/scripts/build.sh" --tags qa "$tagged_todo" 2>&1 >/dev/null)"
contains "$tagged_todo_err" "WARNING: TODO placeholders remain in output:"
contains "$tagged_todo_err" "TODO: qa item"

echo "PASS: build.sh filters tags, removes private metadata, and reliably warns on TODO placeholders"
