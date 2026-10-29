#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v pandoc >/dev/null 2>&1; then
  echo "SKIP: docx output dir test requires pandoc"
  exit 0
fi

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT
mkdir -p "$tmp_dir/home" "$tmp_dir/applications/2026-01-acme-dev"
input="$tmp_dir/applications/2026-01-acme-dev/resume.md"
printf '# Output Dir Check\n\nFixture.\n' > "$input"

fail() { echo "FAIL: $1" >&2; exit 1; }

# Throwaway tracker with a verified row; reset before each build because a build sets it to exported.
export TRACKER="$tmp_dir/tracker.csv"
verify() { printf 'id,status,last_update\n2026-01-acme-dev,verified,\n' > "$TRACKER"; }

# Default: saved in $HOME/Downloads (created if missing), named <folder>-<name>.docx.
verify; HOME="$tmp_dir/home" bash "$repo_root/scripts/build.sh" "$input" <<< y >/dev/null
default_out="$tmp_dir/home/Downloads/2026-01-acme-dev-resume.docx"
[[ -s "$default_out" ]] || fail "default output not at $default_out"
[[ -e "${input%.md}.docx" ]] && fail "docx was also written next to the input"

# RESUME_OUT_DIR overrides the default.
verify; HOME="$tmp_dir/home" RESUME_OUT_DIR="$tmp_dir/custom" bash "$repo_root/scripts/build.sh" "$input" <<< y >/dev/null
[[ -s "$tmp_dir/custom/2026-01-acme-dev-resume.docx" ]] || fail "RESUME_OUT_DIR was ignored"

echo "PASS: build.sh saves docx to Downloads or RESUME_OUT_DIR, not the repo"
