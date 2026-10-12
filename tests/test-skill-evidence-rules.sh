#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
quantifier="$repo_root/skills/resume-quantifier/SKILL.md"
cover_letter="$repo_root/skills/cover-letter-generator/SKILL.md"
ats_optimizer="$repo_root/skills/resume-ats-optimizer/SKILL.md"

fail() {
  echo "FAIL: $1" >&2
  exit 1
}

contains() {
  grep -Fq -- "$2" "$1" || fail "Expected $1 to contain: $2"
}

omits() {
  ! grep -Fq -- "$2" "$1" || fail "Expected $1 to omit: $2"
}

for skill in "$quantifier" "$cover_letter" "$ats_optimizer"; do
  contains "$skill" 'AGENTS.md'
  contains "$skill" 'master/master-resume.md'
  contains "$skill" 'only source of facts'
done

contains "$quantifier" 'Never invent, infer, calculate from unverified inputs, or estimate a metric for application content.'
contains "$quantifier" 'Otherwise, write the bullet without a metric.'
omits "$quantifier" 'Conservative Estimation'
omits "$quantifier" 'Target: 100% of bullets'

contains "$cover_letter" 'A complete cover letter does not need a metric'
contains "$cover_letter" 'a metric is not required'
contains "$cover_letter" 'fictional illustrations and must not be reused'
omits "$cover_letter" 'Includes at least one specific metric/achievement'
omits "$cover_letter" '- Match Score:'
omits "$cover_letter" '5 seconds to grab attention'
omits "$cover_letter" '250-400 words'

contains "$ats_optimizer" 'must not be reused as facts or claims'
contains "$ats_optimizer" 'rather than a predictive ATS score'
omits "$ats_optimizer" '75% of resumes are rejected'
omits "$ats_optimizer" 'Target: 80%+'
omits "$ats_optimizer" 'Estimated New Match Score'

echo "PASS: imported skills follow evidence rules"
