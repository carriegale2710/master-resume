#!/usr/bin/env bash
# Usage: bash scripts/tailor.sh
# Interactive tailoring CLI: job details, then one Claude session per skill, verify-claims until it passes,
# optional cover letter, then runs build.sh on Enter until it marks the tracker row exported.
# Every prompt takes q (quit). Override the CLI with CLAUDE and the tracker
# with TRACKER (tests use both). User-run only: build.sh keeps its own y/N gate and sets ready/exported;
# this script never sets them itself and never commits.
set -euo pipefail
cd "$(dirname "$0")/.."
shopt -s nullglob
claude="${CLAUDE:-claude}"
tracker="${TRACKER:-applications/tracker.csv}"
bf="$(mktemp)"
trap 'rm -f "$bf" "$bf.out"' EXIT

step=1 dir=

# ask PROMPT: prints the prompt, reads $ans (CR stripped). q or EOF quits.
ask() {
  echo "$1"
  IFS= read -r ans || exit 0
  ans="${ans%$'\r'}"
  if [ "$ans" = q ]; then exit 0; fi
}
# status [COLUMN]: the tracker value for this folder (default column: status).
status() { awk -v FPAT='([^,]*)|("([^"]|"")*")' -v k="$(basename "$dir")" -v col="${1:-status}" 'NR==1 { for (i=1;i<=NF;i++) c[$i]=i; next }
  $(c["id"])==k { sub(/\r$/, ""); print $(c[col]) }' "$tracker"; }
run() { "$claude" "/$1 $dir${2:-}" || echo "$1 exited non-zero"; }
slug() { printf %s "$1" | tr 'A-Z_ ' 'a-z--' | tr -cd 'a-z0-9-' | sed 's/^-*//; s/-*$//'; }
# verify [cover]: resume by default; "cover" checks cover-letter.md against cover_letter_status.
# Reset to tailored (cover: drafted) before each run so a re-run after editing is a real re-check.
verify() {
  local cov="${1:-}" col=status reset=tailored file=
  [ -n "$cov" ] && { col=cover_letter_status; reset=drafted; file=/cover-letter.md; }
  while :; do
    bash scripts/set-status.sh "$dir" "$reset" $cov >/dev/null   # $cov unquoted on purpose: empty adds no arg
    run verify-claims "$file"
    [ "$(status "$col")" = verified ] && return 0
    ask "Not verified yet. [Enter] re-run | skip = mark verified without passing"
    [ "$ans" = skip ] && { bash scripts/set-status.sh "$dir" verified $cov >/dev/null; return 0; }
  done
}

cat <<'EOF'
Resume tailoring
Commands (any prompt):
  [Enter]   accept the default (run / start / no)
  s         skip the current step
  y / n     answer yes / no
  <N>       pick a numbered item
  q         quit

EOF
# Start.
apps=(applications/*/)
for i in "${!apps[@]}"; do echo "$((i+1))  ${apps[i]%/}"; done
while [ -z "$dir" ]; do
  ask "Number to resume, or Enter for a new application:"
  case "$ans" in
    "")
      company= role=
      while [ -z "$company" ]; do ask "Company:"; company="$(slug "$ans")"; done
      while [ -z "$role" ]; do ask "Role:"; role="$(slug "$ans")"; done
      if out="$(bash scripts/new-application.sh "$company-$role" 2>&1)"; then
        l="${out%%$'\n'*}"; echo "$l"; dir="${l#Created }"; dir="${dir%% *}"; step=1
      else echo "$out"; fi ;;
    *[!0-9]*) ;;
    *) ans=$((10#$ans))
       if [ "$ans" -ge 1 ] && [ "$ans" -le ${#apps[@]} ]; then
         dir="${apps[ans-1]%/}"
         if grep -qF '(paste posting here)' "$dir/job-description.md"; then step=1; else step=2; fi
       fi ;;
  esac
done

while :; do
  case $step in
    1)
      echo "Step 1/6: Job details"
      jd="$dir/job-description.md"
      ask "Job URL (Enter to skip):"
      url="$ans"
      echo "Paste the job description. Type END on its own line when done."
      : > "$bf"
      # ponytail: a pasted line that is exactly q is read as a command.
      while IFS= read -r ans || [ -n "$ans" ]; do
        ans="${ans%$'\r'}"
        [ "$ans" = END ] && break
        if [ "$ans" = q ]; then exit 0; fi
        printf '%s\n' "$ans" >> "$bf"
      done
      [ -s "$bf" ] || echo "Warning: empty paste, keeping the (paste posting here) placeholder."
      # EOF instead of END leaves $ans empty: skip the closing date and still save.
      if [ "$ans" = END ]; then ask "Closing date (Enter to skip if n/a or already in the posting):"; fi
      URL="$url" CLOSE="$ans" awk -v f="$bf" '
        /^URL:/ && ENVIRON["URL"] != "" { $0 = "URL: " ENVIRON["URL"] }
        /^Closing date:/ && ENVIRON["CLOSE"] != "" { $0 = "Closing date: " ENVIRON["CLOSE"] }
        /^\(paste posting here\)/ && (getline l < f) > 0 { print l; while ((getline l < f) > 0) print l; next }
        { print }' "$jd" > "$bf.out"
      cat "$bf.out" > "$jd"
      step=2 ;;
    2)
      echo "Step 2/6: tracker-intake - fill the tracker row from the job description"
      ask "Run tracker-intake? [Enter] run | s skip"
      [ "$ans" = s ] || run tracker-intake
      step=3 ;;
    3)
      echo "Step 3/6: resume-orchestrator - tailor resume.md (template, draft, review)"
      ask "Run resume-orchestrator? [Enter] run | s skip"
      [ "$ans" = s ] || run resume-orchestrator
      step=4 ;;
    4)
      echo "Step 4/6: verify-claims (loops until verified)"
      # The orchestrator verifies at its end.
      if [ "$(status)" = verified ]; then echo "Already verified, skipping."; else verify; fi
      step=5 ;;
    5)
      echo "Step 5/6: Cover letter (optional)"
      ask "Add a cover letter to go with the resume? [y/N]"
      case "$ans" in [yY]|[yY][eE][sS]) run job-application-agent:cover-letter; verify cover ;; esac
      step=6 ;;
    6)
      echo "Step 6/6: Export"
      echo "Review $dir/resume.md first. Enter runs bash scripts/build.sh $dir/resume.md (it asks its own y/N)."
      while [ "$(status)" != exported ]; do
        ask "Status: $(status). Waiting for export. [Enter] run build.sh | c check status"
        [ -z "$ans" ] && { bash scripts/build.sh "$dir/resume.md" || echo "build.sh exited non-zero"; }
      done
      echo "Exported: $dir"
      exit 0 ;;
  esac
done
