#!/usr/bin/env bash
# Runs the tailor skill in a temp repo copy whose master is the dummy master.
# Real master/ and .env are never copied. Uses the claude CLI; skips if absent.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fixtures="$repo_root/tests/fixtures"

fail() {
  echo "FAIL: $1" >&2
  exit 1
}

command -v claude >/dev/null || { echo "SKIP: claude CLI not on PATH"; exit 0; }

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

# name | job description fixture | tech the dummy master lacks
cases=(
  "backend|jd-backend.md|Go"
  "frontend-qa|jd-frontend-qa.md|Kubernetes"
)

for c in "${cases[@]}"; do
  IFS='|' read -r name jd banned <<< "$c"

  work="$tmp_dir/$name"
  mkdir -p "$work/master" "$work/applications/2026-10-sample-$name"
  cp "$repo_root/AGENTS.md" "$repo_root/CLAUDE.md" "$work/"
  cp -r "$repo_root/skills" "$repo_root/scripts" "$work/"
  cp "$fixtures/dummy-master.md" "$work/master/master-resume.md"
  cp "$fixtures/$jd" "$work/applications/2026-10-sample-$name/job-description.md"

  (cd "$work" && claude -p \
    "Follow AGENTS.md and skills/resume-tailor-quick/SKILL.md. Tailor a resume for applications/2026-10-sample-$name/job-description.md. Write it to applications/2026-10-sample-$name/resume.md." \
    --permission-mode acceptEdits \
    --allowedTools "Bash(bash scripts/*)" >/dev/null)

  out="$work/applications/2026-10-sample-$name/resume.md"
  [[ -s "$out" ]] || fail "$name: resume.md not written"
  ! grep -q "PRIVATE_SENTINEL" "$out" || fail "$name: private section leaked"
  ! grep -Eqw "$banned" "$out" || fail "$name: invented skill: $banned"
done

echo "PASS: tailor skill stays within dummy master (no private leak, no invented skills)"
