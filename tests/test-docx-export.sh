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

# Cover letter: gated on cover_letter_status, keeps line breaks, leaves resume status alone.
letter_dir="$tmp_dir/synthetic-app"
mkdir -p "$letter_dir"
printf 'Synthetic Sender\nSynthetic Street\n\nYours sincerely,\nSynthetic Sender\n' > "$letter_dir/cover-letter.md"
printf 'id,status,last_update,cover_letter_status\nsynthetic-app,exported,,drafted\n' > "$TRACKER"
if RESUME_OUT_DIR="$out_dir" bash "$repo_root/scripts/build.sh" "$letter_dir/cover-letter.md" <<< y >/dev/null 2>&1; then
  echo "FAIL: build.sh built a cover letter that is not verified" >&2
  exit 1
fi
printf 'id,status,last_update,cover_letter_status\nsynthetic-app,exported,,verified\n' > "$TRACKER"
RESUME_OUT_DIR="$out_dir" bash "$repo_root/scripts/build.sh" "$letter_dir/cover-letter.md" <<< y >/dev/null
[[ -s "$out_dir/synthetic-app-cover-letter.docx" ]] || { echo "FAIL: no cover letter docx" >&2; exit 1; }
grep -q '^synthetic-app,exported,' "$TRACKER" || { echo "FAIL: cover letter build changed resume status" >&2; exit 1; }
if command -v unzip >/dev/null 2>&1; then
  unzip -p "$out_dir/synthetic-app-cover-letter.docx" word/document.xml | grep -q '<w:br' ||
    { echo "FAIL: cover letter lost its line breaks" >&2; exit 1; }
fi

echo "PASS: build.sh exports a verified cover letter"

# Output dir: default $HOME/Downloads, RESUME_OUT_DIR overrides.
mkdir -p "$tmp_dir/home" "$tmp_dir/applications/2026-01-acme-dev"
od_input="$tmp_dir/applications/2026-01-acme-dev/resume.md"
printf '# Output Dir Check\n\nFixture.\n' > "$od_input"

fail() { echo "FAIL: $1" >&2; exit 1; }

# Reset before each build because a build sets it to exported.
verify() { printf 'id,status,last_update\n2026-01-acme-dev,verified,\n' > "$TRACKER"; }

# Default: saved in $HOME/Downloads (created if missing), named <folder>-<name>.docx.
verify; HOME="$tmp_dir/home" bash "$repo_root/scripts/build.sh" "$od_input" <<< y >/dev/null
default_out="$tmp_dir/home/Downloads/2026-01-acme-dev-resume.docx"
[[ -s "$default_out" ]] || fail "default output not at $default_out"
[[ -e "${od_input%.md}.docx" ]] && fail "docx was also written next to the input"

# RESUME_OUT_DIR overrides the default.
verify; HOME="$tmp_dir/home" RESUME_OUT_DIR="$tmp_dir/custom" bash "$repo_root/scripts/build.sh" "$od_input" <<< y >/dev/null
[[ -s "$tmp_dir/custom/2026-01-acme-dev-resume.docx" ]] || fail "RESUME_OUT_DIR was ignored"

echo "PASS: build.sh saves docx to Downloads or RESUME_OUT_DIR, not the repo"
