---
name: resume-orchestrator
description: Run the whole tailoring step for applications/<folder> in one session: analyse the posting, pick a template, draft with resume-drafter, review with resume-ats-optimizer, then use other resume-* skills only when the audit or the user's feedback needs them. Use for step 3 of scripts/tailor.sh or when asked to tailor end to end.
---

# Resume orchestrator

Input: `<folder>`. `AGENTS.md` wins over any sub-skill. Never run `build.sh` or `tracker-intake`, and never edit `master/`.

1. Run `job-description-analyzer` on `applications/<folder>/job-description.md`. Keep must-haves, role family and whether it is a tech role. No match score or percentage. Never add gaps as claims.
2. Use `templates/resume.md` (the only resume template).
3. Run `resume-drafter` with that template. It writes `resume.md` and sets `tailored`.
4. Run `resume-ats-optimizer` on the draft. For tech roles only, also run `tech-resume-optimizer`; ignore its Technical Skills section advice (the universal checklist bans a generic Skills section).
5. Any other `resume-*` skill may be used when the audit or the user's feedback calls for it (for example `resume-bullet-writer` for weak bullets, `resume-quantifier` when a `master/metrics-log.csv` row is unused). Master facts only; no new numbers.
6. Show all proposed edits (location, old text, new text, master source). Apply only the ones the user approves. Repeat on feedback until the user says done.
7. Run `bash scripts/set-status.sh <folder> tailored`. Report what was cut, what was reworded, every claim that still needs evidence, and which skills ran.
8. Run `verify-claims` on `resume.md`. On FAIL, show its issues as proposed edits, apply the approved ones, run `bash scripts/set-status.sh <folder> tailored` and verify again. On PASS (status `verified`), end with one line: "Verified. Type /exit to return to the CLI." An agent cannot close its own session.
