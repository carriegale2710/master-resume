#!/usr/bin/env bash
# Usage:
#   ./scripts/build.sh [--tags a,b,c] [--md-only] input.md
# --tags     keep only tagged bullets matching any tag (untagged lines kept)
# --md-only  print filtered Markdown to stdout instead of building a .docx
# docx build requires tracker status "verified" and a y/N approval (sets ready, then exported).
# The .docx needs pandoc only; optional templates/reference.docx styles it.
# Single line breaks are kept. cover-letter.md: gated on cover_letter_status=verified (no ready/exported change),
# styled by templates/cover-letter-reference.docx if present, else templates/reference.docx.
# Everything from the first "## 6."-"## 10." heading on (master section 6 is private), tag/variant keys
# and "> " notes are always removed. Private side files in master/ are never read.
# docx build only: ${RESUME_NAME|EMAIL|LOCATION|PHONE|LINKS|WORKRIGHTS} and ${GITHUB_URL|LINKEDIN_URL|PORTFOLIO_URL}
# placeholders come from .env
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
  ' "$in" | sed -E 's/`[a-z][a-z0-9-]*` ?//g'
  # ponytail: strips any lowercase-kebab `token` (every Tag key tag); list tags explicitly if a resume needs inline code like `npm`.
}

if [ "$md_only" -eq 1 ]; then filter; exit 0; fi

stem="$(basename "$in" .md)"; folder="$(basename "$(dirname "$(realpath "$in")")")"
# cover-letter.md is gated on cover_letter_status and leaves the resume status alone.
cover=0; [ "$stem" = cover-letter ] && cover=1
col=status; [ "$cover" -eq 1 ] && col=cover_letter_status
# Approval gate: only a verified draft builds; the y/N prompt is the human sign-off (sets ready).
tracker="${TRACKER:-$(dirname "$0")/../applications/tracker.csv}"
status="$(awk -F, -v k="$folder" -v col="$col" 'NR==1 { for (i=1;i<=NF;i++) c[$i]=i; next } $(c["id"])==k { print $(c[col]) }' "$tracker")"
[ "$status" = "verified" ] || { echo "$col is '${status:-no tracker row}', not verified. Run verify-claims first." >&2; exit 1; }
read -r -p "Approve $folder $stem and build docx? [y/N] " ok
[[ "$ok" =~ ^[Yy]$ ]] || { echo "Not approved." >&2; exit 1; }
[ "$cover" -eq 1 ] || bash "$(dirname "$0")/set-status.sh" "$folder" ready

todo_matches="$(filter | grep -n 'TODO' || true)"
if [ -n "$todo_matches" ]; then
  echo "WARNING: TODO placeholders remain in output:" >&2
  printf '%s\n' "$todo_matches" >&2
fi

md="$(filter)"
# Private header: ${RESUME_*} and ${*_URL} placeholders are filled from .env at docx build time only.
if grep -Eq '\$\{(RESUME_|GITHUB_URL|LINKEDIN_URL|PORTFOLIO_URL)' <<<"$md"; then
  env_file="${RESUME_ENV_FILE:-$(dirname "$0")/../.env}"
  [ -f "$env_file" ] || { echo "Missing $env_file" >&2; exit 1; }
  set -a; . "$env_file"; set +a
  for v in RESUME_NAME RESUME_EMAIL RESUME_LOCATION RESUME_PHONE RESUME_WORKRIGHTS GITHUB_URL LINKEDIN_URL PORTFOLIO_URL; do
    tok='${'"$v"'}'
    [[ "$md" == *"$tok"* ]] || continue
    if [ -z "${!v:-}" ]; then
      # *_URL placeholders are optional: drop them with their " | " separator.
      [[ "$v" == *_URL ]] || { echo "Missing $v in $env_file" >&2; exit 1; }
      md="${md//" | $tok"/}"; md="${md//"$tok | "/}"; md="${md//"$tok"/}"
      continue
    fi
    md="${md//"$tok"/"${!v}"}"
  done
fi
out_dir="${RESUME_OUT_DIR:-$HOME/Downloads}"
mkdir -p "$out_dir"
out="$out_dir/$folder-$stem.docx"
ref="$(dirname "$0")/../templates/reference.docx"
if [ "$cover" -eq 1 ]; then
  cref="$(dirname "$0")/../templates/cover-letter-reference.docx"
  [ -f "$cref" ] && ref="$cref"
fi
ref_opt=(); [ -f "$ref" ] && ref_opt=(--reference-doc="$ref")
# hard_line_breaks: each source line (headline, contacts, education entries, letter address block) stays its own line.
printf '%s\n' "$md" | pandoc -f markdown+hard_line_breaks -t docx "${ref_opt[@]}" -o "$out"
echo "Built $out"
[ "$cover" -eq 1 ] || bash "$(dirname "$0")/set-status.sh" "$folder" exported || true
