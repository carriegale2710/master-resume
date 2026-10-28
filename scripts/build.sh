#!/usr/bin/env bash
# Usage:
#   ./scripts/build.sh [--tags a,b,c] [--md-only] input.md
# --tags     keep only tagged bullets matching any tag (untagged lines kept)
# --md-only  print filtered Markdown to stdout instead of building a .docx
# The .docx needs pandoc only; optional templates/reference.docx styles it.
# Private sections (6-10), tag/variant keys and "> " notes are always removed.
# docx build only: ${RESUME_NAME|EMAIL|PHONE|LINKS} placeholders come from .env
# (override path with RESUME_ENV_FILE). --md-only never reads .env.
# The .docx is saved to ~/Downloads as <folder>-<name>.docx (override with RESUME_OUT_DIR).
set -euo pipefail

tags=""; md_only=0; in=""
while [ $# -gt 0 ]; do
  case "$1" in
    --tags) tags="$2"; shift 2 ;;
    --md-only) md_only=1; shift ;;
    *) in="$1"; shift ;;
  esac
done
[ -n "$in" ] || { echo "No input file" >&2; exit 1; }

filter() {
  awk -v tags="$tags" '
    BEGIN { n = split(tags, t, ","); keep = 1 }
    /^## (6|7|8|9|10)\./ { exit }
    /^> / || /^\*\*Tag key/ || /^\*\*Variant key/ { next }
    /^- `/ {
      keep = (tags == "") ? 1 : 0
      for (i = 1; i <= n; i++) if (index($0, "`" t[i] "`")) keep = 1
      if (keep) print
      next
    }
    /^  - / { if (keep) print; next }
    { keep = 1; print }
  ' "$in" | sed -E 's/`(fullstack|backend|frontend|qa|ux|a11y|ai-eval|devops|product|leadership|security)` ?//g'
}

if [ "$md_only" -eq 1 ]; then filter; exit 0; fi

todo_matches="$(filter | grep -n 'TODO' || true)"
if [ -n "$todo_matches" ]; then
  echo "WARNING: TODO placeholders remain in output:" >&2
  printf '%s\n' "$todo_matches" >&2
fi

md="$(filter)"
# Private header: ${RESUME_*} placeholders are filled from .env at docx build time only.
if grep -q '\${RESUME_' <<<"$md"; then
  env_file="${RESUME_ENV_FILE:-$(dirname "$0")/../.env}"
  [ -f "$env_file" ] || { echo "Missing $env_file" >&2; exit 1; }
  set -a; . "$env_file"; set +a
  for v in RESUME_NAME RESUME_EMAIL RESUME_PHONE RESUME_LINKS; do
    [ -n "${!v:-}" ] || { echo "Missing $v in $env_file" >&2; exit 1; }
    tok='${'"$v"'}'
    md="${md//"$tok"/"${!v}"}"
  done
fi
out_dir="${RESUME_OUT_DIR:-$HOME/Downloads}"
mkdir -p "$out_dir"
stem="$(basename "$in" .md)"; folder="$(basename "$(dirname "$(realpath "$in")")")"
out="$out_dir/$folder-$stem.docx"
ref="$(dirname "$0")/../templates/reference.docx"
ref_opt=(); [ -f "$ref" ] && ref_opt=(--reference-doc="$ref")
printf '%s\n' "$md" | pandoc -f markdown -t docx "${ref_opt[@]}" -o "$out"
echo "Built $out"
