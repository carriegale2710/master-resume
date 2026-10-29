#!/usr/bin/env bash
# Structural check: the real master is split into section 0-6 plus private side files.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
master="$repo_root/master"

fail() {
  echo "FAIL: $1" >&2
  exit 1
}

for f in skills-inventory.csv metrics-log.csv narrative-notes.md archive.md; do
  [[ -s "$master/$f" ]] || fail "missing or empty: master/$f"
done
head -n 1 "$master/skills-inventory.csv" | grep -q '^Category,' || fail "skills-inventory.csv: no header row"
head -n 1 "$master/metrics-log.csv" | grep -q '^Claim,' || fail "metrics-log.csv: no header row"
for f in narrative-notes.md archive.md; do
  grep -q '^#' "$master/$f" || fail "$f: no top-level heading"
done

grep -q '^## 6\. Private constraints' "$master/master-resume.md" || fail "master-resume.md: no section 6 private constraints heading"
! grep -Eq '^## (7|8|9|10)\.' "$master/master-resume.md" || fail "master-resume.md still has sections 7-10"

echo "PASS: master split into master-resume.md (sections 0-6) plus private side files"
