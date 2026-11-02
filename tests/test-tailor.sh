#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp_root="$(mktemp -d)"
trap 'rm -rf "$tmp_root"' EXIT

fail() {
  echo "FAIL: $1" >&2
  exit 1
}

# Stub claude: log each prompt; /verify-claims bumps a counter and marks verified on the calls listed in STUB_PASS.
cat > "$tmp_root/claude-stub" <<'EOF'
#!/usr/bin/env bash
echo "$*" >> "$T/claude.log"
case "$1" in /verify-claims\ *)
  n=$(( $(cat "$T/count" 2>/dev/null || echo 0) + 1 )); echo "$n" > "$T/count"
  case " $STUB_PASS " in *" $n "*) bash "$T/scripts/set-status.sh" "${1#* }" verified >/dev/null ;; esac ;;
/resume-orchestrator\ *) [ "${STUB_ORCH_VERIFIES:-}" = 1 ] && bash "$T/scripts/set-status.sh" "${1#* }" verified >/dev/null ;;
esac
exit 0
EOF
chmod +x "$tmp_root/claude-stub"
export CLAUDE="$tmp_root/claude-stub"

# Fresh sandbox per scenario: copied scripts and templates, build.sh replaced by a logger
# that marks the row exported only when BUILD_EXPORTS=1 (the real build never runs in tests).
# TRACKER sits outside applications/ so every script must honour it.
new() {
  T="$(mktemp -d -p "$tmp_root")"
  export T TRACKER="$T/tracker.csv"
  mkdir -p "$T/templates" "$T/applications"
  cp -r "$repo_root/scripts" "$T/"
  cp "$repo_root/templates/resume.md" "$T/templates/"
  cat > "$T/scripts/build.sh" <<'EOF'
#!/usr/bin/env bash
echo "$*" >> "$T/build.log"
[ "${BUILD_EXPORTS:-}" = 1 ] && bash "$T/scripts/set-status.sh" "$(dirname "$1")" exported >/dev/null
exit 0
EOF
  : > "$T/claude.log"; : > "$T/build.log"
}
to=(); command -v timeout >/dev/null && to=(timeout 20)
# Finite piped input: EOF ends any read loop, timeout catches the rest.
run() { (cd "$T" && printf '%b' "$2" | STUB_PASS="$1" "${to[@]}" bash scripts/tailor.sh) > "$T/out" 2>&1; }
status() { awk -F, -v k="$(basename "$1")" 'NR==1 { for (i=1;i<=NF;i++) c[$i]=i; next } $(c["id"])==k { print $(c["status"]) }' "$TRACKER"; }
count() { grep -c "^/verify-claims " "$T/claude.log" || true; }

dir="applications/$(date +%Y-%m)-acme-corp-frontend-dev"
jd() { echo "$T/$dir/job-description.md"; }
# Start (Enter = new), company, role, checklist Enter, URL, JD + END, closing date,
# run tracker-intake, run orchestrator. Step 4 verify runs next with no pre-prompt.
pre="\nAcme Corp\nFrontend Dev\n\nhttps://example.com/job\nJD line one\nJD line two\nEND\n2026-12-01\n\n\n"

# 1. New app + JD capture. At step 6: c checks status, Enter runs build.sh (stub leaves status verified);
# b 4 after q must never run.
new; rc=0; run 1 "${pre}n\nc\n\nq\nb 4\n" || rc=$?
[[ -f "$(jd)" ]] || fail "1: $dir not created"
grep -q 'https://example.com/job' "$(jd)" || fail "1: URL missing from JD"
grep -q 'JD line one' "$(jd)" && grep -q 'JD line two' "$(jd)" || fail "1: JD lines missing"
grep -q 'Closing date: *2026-12-01' "$(jd)" || fail "1: closing date missing"
if grep -qF '(paste posting here)' "$(jd)"; then fail "1: placeholder not replaced"; fi
[[ "$(tail -n +2 "$TRACKER" | wc -l)" -eq 1 ]] || fail "1: tracker should have one row"

# 2. Happy path order; step 6 waits, q exits 0 and stops reading.
[[ $rc -eq 0 ]] || fail "2: tailor.sh exited $rc"
expected="/tracker-intake $dir
/resume-orchestrator $dir
/verify-claims $dir"
[[ "$(cat "$T/claude.log")" == "$expected" ]] || fail "2: wrong skill order, got: $(cat "$T/claude.log")"
[[ "$(grep -c 'Waiting for export' "$T/out")" -ge 3 ]] || fail "2: step 6 did not keep waiting after c and a non-exporting build"

# 6. Enter at step 6 runs build.sh once on the resume (c does not); the script never sets exported itself.
[[ "$(cat "$T/build.log")" == "$dir/resume.md" ]] || fail "6: want one build.sh $dir/resume.md, got: $(cat "$T/build.log")"
[[ "$(status "$dir")" == verified ]] || fail "6: status should stay verified, got: $(status "$dir")"

# 7. Commands shown once in the welcome screen, before step 1, with b <N> and q.
[[ "$(grep -c '^Step [1-6]/6' "$T/out")" -ge 6 ]] || fail "7: fewer than 6 step headers"
[[ "$(grep -c '^Commands' "$T/out")" -eq 1 ]] || fail "7: want exactly one Commands block"
[[ "$(grep -n '^Commands' "$T/out" | cut -d: -f1)" -lt "$(grep -n '^Step 1/6' "$T/out" | head -1 | cut -d: -f1)" ]] || fail "7: Commands not before step 1"
grep -q 'b <N>' "$T/out" && grep -q '^  q ' "$T/out" || fail "7: welcome missing b <N> or q"

# 3. verify-claims loops until pass: Enter re-runs, stub passes on call 2.
new; run 2 "${pre}\nn\nq\n" || fail "3: tailor.sh exited non-zero"
[[ "$(count)" -eq 2 ]] || fail "3: verify-claims ran $(count) times, want 2"

# 4. Only the word skip bypasses verify: s re-runs, skip marks verified.
new; run "" "${pre}s\nskip\nn\nq\n" || fail "4: tailor.sh exited non-zero"
[[ "$(count)" -eq 2 ]] || fail "4: verify-claims ran $(count) times, want 2"
[[ "$(status "$dir")" == verified ]] || fail "4: skip did not mark verified"

# 5. Back: b 4 resets to tailored and re-verifies (fails, skip); b 5 + y runs cover letter then verify.
new; run "1 3" "${pre}n\nb 4\nskip\nn\nb 5\ny\nq\n" || fail "5: tailor.sh exited non-zero"
grep -q 'Not verified yet' "$T/out" || fail "5: b 4 did not reset to tailored before verify"
[[ "$(count)" -eq 3 ]] || fail "5: verify-claims ran $(count) times, want 3"
[[ "$(tail -n 2 "$T/claude.log")" == "/cover-letter-generator $dir
/verify-claims $dir" ]] || fail "5: cover letter not followed by verify, got: $(tail -n 2 "$T/claude.log")"

# 8. Edge input: b N before a new app still starts at step 1; JD ending at EOF (no END, no newline) is saved.
new; run 1 "b 5\n\nAcme Corp\nFrontend Dev\n\nhttps://example.com/job\nJD line one\nJD tail" || fail "8: tailor.sh exited non-zero"
grep -q 'JD line one' "$(jd)" && grep -q 'JD tail' "$(jd)" || fail "8: JD not saved (b N skipped step 1, or EOF lost the paste)"
# Replace JD (Y), then quit mid-step: old JD stays.
run 1 "1\n\nb 1\nY\nq\n" || fail "8: tailor.sh exited non-zero on replace"
grep -q 'Job URL' "$T/out" || fail "8: Y not accepted at Replace existing JD"
grep -q 'JD line one' "$(jd)" || fail "8: quitting mid-replace deleted the old JD"
# Leading-zero number picks folder 8, no base-8 crash.
new; mkdir -p "$T"/applications/a{1..9}; touch "$T"/applications/a{1..9}/job-description.md
run 1 "08\n\nq\n" || fail "8: 08 crashed tailor.sh"
grep -q '^Step 2/6' "$T/out" || fail "8: 08 did not resume a folder"

# 9. Export: Enter runs build.sh, which marks the row exported, and the CLI exits 0 without more input.
new; BUILD_EXPORTS=1 run 1 "${pre}n\n\n" || fail "9: tailor.sh exited non-zero"
grep -q "^Exported: $dir" "$T/out" || fail "9: CLI did not finish on exported"
[[ "$(status "$dir")" == exported ]] || fail "9: status should be exported, got: $(status "$dir")"

# 10. Orchestrator already verified: step 4 skips verify-claims.
new; STUB_ORCH_VERIFIES=1 run "" "${pre}n\nq\n" || fail "10: tailor.sh exited non-zero"
grep -q 'Already verified, skipping' "$T/out" || fail "10: step 4 did not skip a verified row"
[[ "$(count)" -eq 0 ]] || fail "10: verify-claims ran $(count) times, want 0"

echo "PASS: tailor.sh guardrails (JD capture, order, verify loop, skip, back, build + export, commands, edge input)"
