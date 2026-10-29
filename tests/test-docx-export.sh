#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v pandoc >/dev/null 2>&1; then
  echo "SKIP: docx export requires pandoc"
  exit 0
fi

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT
input="$tmp_dir/synthetic-resume.md"
out_dir="$tmp_dir/out"

cat > "$input" <<'EOF'
# Synthetic Docx Export Check

Docx export regression fixture.
EOF

# Throwaway tracker with a verified row so the approval gate passes; y answers the prompt.
export TRACKER="$tmp_dir/tracker.csv"
printf 'id,status,last_update\n%s,verified,\n' "$(basename "$tmp_dir")" > "$TRACKER"
RESUME_OUT_DIR="$out_dir" bash "$repo_root/scripts/build.sh" "$input" <<< y >/dev/null
docx="$(ls "$out_dir"/*-synthetic-resume.docx)"
[[ -s "$docx" ]] || {
  echo "FAIL: build.sh did not create a non-empty docx" >&2
  exit 1
}
[[ "$(head -c 2 "$docx")" == 'PK' ]] || {
  echo "FAIL: build.sh output does not have a zip (docx) signature" >&2
  exit 1
}

echo "PASS: build.sh exports a synthetic docx"
