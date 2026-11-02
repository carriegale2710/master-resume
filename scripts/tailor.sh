#!/usr/bin/env bash
# Usage: bash scripts/tailor.sh
# Interactive tailoring CLI: job details, then one Claude session per skill, verify-claims until it passes,
# optional cover letter, then runs build.sh on Enter until it marks the tracker row exported.
# Every prompt takes b <N> (back to step N) and q (quit). Override the CLI with CLAUDE and the tracker
# with TRACKER (tests use both). User-run only: build.sh keeps its own y/N gate and sets ready/exported;
# this script never sets them itself and never commits.
set -euo pipefail
cd "$(dirname "$0")/.."
shopt -s nullglob
claude="${CLAUDE:-claude}"
tracker="${TRACKER:-applications/tracker.csv}"
bf="$(mktemp)"
trap 'rm -f "$bf" "$bf.out"' EXIT

skill=([2]=tracker-intake [3]=resume-orchestrator)
desc=([2]="fill the tracker row from the job description" [3]="tailor resume.md (template, draft, review)")
on=([2]=1 [3]=1)
step=1 jump= dir=

# Global commands: q exits; b/back N jumps (returns 1 so the caller restarts the loop at $step).
cmd() {
  case "$ans" in
    q) exit 0 ;;
    b\ [1-6]|back\ [1-6]) step="${ans##* }"; jump=$step; return 1 ;;
  esac
}
# ask PROMPT STEP_COMMANDS: prints the prompt and commands line, reads $ans (CR stripped). EOF quits.
ask() {
  while :; do
    echo "$1"
    IFS= read -r ans || exit 0
    ans="${ans%$'\r'}"
    case "$ans" in b\ [1-6]|back\ [1-6]) ;; b\ *|back\ *) echo "Step must be 1-6."; continue ;; esac
    cmd; return
  done
}
status() { awk -F, -v k="$(basename "$dir")" 'NR==1 { for (i=1;i<=NF;i++) c[$i]=i; next }
  $(c["id"])==k { sub(/\r$/, ""); print $(c["status"]) }' "$tracker"; }
run() { "$claude" "/$1 $dir${2:-}" || echo "$1 exited non-zero"; }
slug() { printf %s "$1" | tr 'A-Z_ ' 'a-z--' | tr -cd 'a-z0-9-' | sed 's/^-*//; s/-*$//'; }
# Reset to tailored before each run so a re-run after editing is a real re-check. Returns 1 on b N.
verify() {
  while :; do
    bash scripts/set-status.sh "$dir" tailored >/dev/null
    run verify-claims
    [ "$(status)" = verified ] && return 0
    ask "Not verified yet." "[Enter] re-run | skip mark verified without passing" || return 1
    [ "$ans" = skip ] && { bash scripts/set-status.sh "$dir" verified >/dev/null; return 0; }
  done
}

cat <<'EOF'
Resume tailoring
Commands (any prompt):
  [Enter]   accept the default (run / start / no)
  s         skip the current step
  y / n     answer yes / no
  <N>       pick a numbered item
  b <N>     back to step N (1-6)
  q         quit

EOF
# Start. ponytail: b N here re-asks (no folder yet to jump within).
apps=(applications/*/)
for i in "${!apps[@]}"; do echo "$((i+1))  ${apps[i]%/}"; done
while [ -z "$dir" ]; do
  ask "Number to resume, or Enter for a new application:" "<N> resume | [Enter] new" || continue
  case "$ans" in
    "")
      company= role=
      while [ -z "$company" ]; do ask "Company:" "" && company="$(slug "$ans")"; done
      while [ -z "$role" ]; do ask "Role:" "" && role="$(slug "$ans")"; done
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
jump=

# Toggle checklist: off steps are skipped going forward; b N to one runs it anyway.
while :; do
  for n in 2 3; do
    if [ "${on[n]}" = 1 ]; then x=x; else x=' '; fi
    echo "$n [$x] ${skill[n]} - ${desc[n]}"
  done
  ask "Toggle a step, or Enter to start:" "2/3 toggle | [Enter] start" || break
  case "$ans" in "") break ;; 2|3) on[ans]=$((1 - on[ans])) ;; esac
done

while :; do
  case $step in
    1)
      echo "Step 1/6: Job details"
      jd="$dir/job-description.md"
      if ! grep -qF '(paste posting here)' "$jd"; then
        ask "Replace existing JD? [y/N]" "y replace | [Enter] keep" || continue
        case "$ans" in [yY]|[yY][eE][sS]) ;; *) step=2; continue ;; esac
      fi
      ask "Job URL (Enter to skip):" "" || continue
      url="$ans"
      echo "Paste the job description. Type END on its own line when done."
      : > "$bf"
      # ponytail: a pasted line that is exactly q or b N is read as a command.
      while IFS= read -r ans || [ -n "$ans" ]; do
        ans="${ans%$'\r'}"
        [ "$ans" = END ] && break
        cmd || continue 2
        printf '%s\n' "$ans" >> "$bf"
      done
      [ -s "$bf" ] || echo "Warning: empty paste, keeping the (paste posting here) placeholder."
      # EOF instead of END leaves $ans empty: skip the closing date and still save.
      if [ "$ans" = END ]; then ask "Closing date (Enter to skip if n/a or already in the posting):" "" || continue; fi
      # Replacing: drop the old body only now, so an abort above leaves the file untouched.
      grep -qF '(paste posting here)' "$jd" || { sed -i '/^Closing date:/q' "$jd"; printf '\n(paste posting here)\n' >> "$jd"; }
      URL="$url" CLOSE="$ans" awk -v f="$bf" '
        /^URL:/ && ENVIRON["URL"] != "" { $0 = "URL: " ENVIRON["URL"] }
        /^Closing date:/ && ENVIRON["CLOSE"] != "" { $0 = "Closing date: " ENVIRON["CLOSE"] }
        /^\(paste posting here\)/ && (getline l < f) > 0 { print l; while ((getline l < f) > 0) print l; next }
        { print }' "$jd" > "$bf.out"
      cat "$bf.out" > "$jd"
      step=2 ;;
    2|3)
      s="${skill[step]}"
      echo "Step $step/6: $s - ${desc[step]}"
      if [ "${on[step]}" != 1 ] && [ "$jump" != "$step" ]; then
        echo "Off in the checklist, skipping."; step=$((step + 1)); continue
      fi
      jump=
      ask "Run $s?" "[Enter] run | s skip" || continue
      case "$ans" in
        "") run "$s"; step=$((step + 1)) ;;
        s) step=$((step + 1)) ;;
      esac ;;
    4)
      echo "Step 4/6: verify-claims (loops until verified)"
      # The orchestrator verifies at its end; only b 4 forces a re-check of an already verified row.
      if [ "$(status)" = verified ] && [ "$jump" != 4 ]; then echo "Already verified, skipping."
      else jump=; verify || continue; fi
      step=5 ;;
    5)
      echo "Step 5/6: Cover letter (optional)"
      ask "Add a cover letter to go with the resume? [y/N]" "y yes | [Enter] no" || continue
      case "$ans" in [yY]|[yY][eE][sS]) run job-application-agent:cover-letter; verify || continue ;; esac
      step=6 ;;
    6)
      echo "Step 6/6: Export"
      echo "Review $dir/resume.md first. Enter runs bash scripts/build.sh $dir/resume.md (it asks its own y/N)."
      while [ "$(status)" != exported ]; do
        ask "Status: $(status). Waiting for export." "[Enter] run build.sh | c check status" || continue 2
        [ -z "$ans" ] && { bash scripts/build.sh "$dir/resume.md" || echo "build.sh exited non-zero"; }
      done
      echo "Exported: $dir"
      exit 0 ;;
  esac
done
