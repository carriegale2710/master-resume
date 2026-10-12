#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v pandoc >/dev/null 2>&1 || ! command -v weasyprint >/dev/null 2>&1; then
  echo "SKIP: PDF export requires both pandoc and weasyprint"
  exit 0
fi

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT
input="$tmp_dir/synthetic-resume.md"
pdf="$tmp_dir/synthetic-resume.pdf"

cat > "$input" <<'EOF'
# Synthetic PDF Export Check

PDF export regression fixture.
EOF

bash "$repo_root/scripts/build.sh" "$input" >/dev/null
[[ -s "$pdf" ]] || {
  echo "FAIL: build.sh did not create a non-empty PDF" >&2
  exit 1
}
[[ "$(head -c 5 "$pdf")" == '%PDF-' ]] || {
  echo "FAIL: build.sh output does not have a PDF signature" >&2
  exit 1
}

echo "PASS: build.sh exports a synthetic PDF"
