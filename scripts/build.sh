#!/usr/bin/env bash
# Usage:
#   ./scripts/build.sh [--tags a,b,c] [--md-only] input.md
# --tags     keep only tagged bullets matching any tag (untagged lines kept)
# --md-only  print filtered Markdown to stdout instead of building a PDF
# Private sections (6-10), tag/variant keys and "> " notes are always removed.
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

out="${in%.md}.pdf"
filter | pandoc -f markdown -t html5 --standalone --metadata title=" " \
  --css "$(dirname "$0")/../templates/style.css" --pdf-engine=weasyprint -o "$out"
echo "Built $out"
