---
name: resume-orchestrator
description: Run the whole tailoring step for applications/<folder> in one session: analyse the posting, pick a template, draft with resume-drafter, review with job-application-agent:application-lint, then use other plugin skills only when the audit or the user's feedback needs them. Use for step 3 of scripts/tailor.sh or when asked to tailor end to end.
---

# Resume orchestrator

Input: `<folder>`. `AGENTS.md` wins over any sub-skill. Never run `build.sh` or `tracker-intake`, and never edit `master/` except by master write-back (`AGENTS.md`).

1. Run `job-application-agent:job-ad-decoder` on `applications/<folder>/job-description.md`; it writes `applications/<folder>/criteria.md`. Keep must-haves, role family and whether it is a tech role. No match score or percentage. Never add gaps as claims.
2. Use `templates/resume.md` (the only resume template).
3. Run `resume-drafter` with that template. It writes `resume.md` and sets `tailored`.
4. Run `job-application-agent:application-lint` on the draft with `--type resume --keywords applications/<folder>/criteria.md`. Ignore any advice that conflicts with `AGENTS.md` or `tailoring-rules/` (for example a generic Skills section, or dates on projects).
5. Check the draft against `tailoring-rules/every-resume.md`, the matching role checklist in `tailoring-rules/by-role/` and, where they apply, `tailoring-rules/by-company/graduate.md`, `startup.md` and `industry.md`. Tick every item; fix any that fail and re-check. Report any item you could not fix. `AGENTS.md` privacy and source-of-truth rules win on conflict.
6. Other plugin skills may be used when the audit or the user's feedback calls for it (for example `job-application-agent:achievement-statements` for weak bullets or when a `master/metrics-log.csv` row is unused, `job-application-agent:section-architect` for section order and cuts). Master facts only; no new numbers.
7. Show all proposed edits (location, old text, new text, master source). Apply only the ones the user approves. Repeat on feedback until the user says done.
8. Run `bash scripts/set-status.sh <folder> tailored`. Report what was cut, what was reworded, every claim that still needs evidence, and which skills ran.
9. Run `verify-claims` on `resume.md`. On FAIL, show its issues as proposed edits, apply the approved ones, run `bash scripts/set-status.sh <folder> tailored` and verify again. On PASS (status `verified`), end with one line: "Verified. Type /exit to return to the CLI." An agent cannot close its own session.
