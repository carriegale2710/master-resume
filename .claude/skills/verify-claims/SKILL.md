---
name: verify-claims
description: Audit a tailored resume or cover letter for unsupported numbers, estimates presented as facts, leaked private content, TODO placeholders and inconsistencies against the master. Mandatory final step before an application is called ready.
---

# Verify claims

Inputs: the file to check, `master/master-resume.md` (especially section 6 private constraints), `master/metrics-log.csv` (read in full), and `master/narrative-notes.md` and `master/archive.md` (for leak checks only).

Check, in order:
1. **Numbers.** Every number, percentage and count must match a `master/metrics-log.csv` row. Classify each as Fact, Estimate, Projection, Self-reported or Unlisted.
2. **Unsafe claims.** Estimates, projections and unlisted numbers must use the log's safe wording, or be flagged for the user to supply evidence.
3. **TODO.** Any remaining `TODO` or missing contact/link must be listed. `${RESUME_NAME}`, `${RESUME_EMAIL}`, `${RESUME_LOCATION}`, `${RESUME_PHONE}`, `${RESUME_WORKRIGHTS}`, `${GITHUB_URL}`, `${LINKEDIN_URL}` and `${PORTFOLIO_URL}` are intentional placeholders filled from `.env` at docx build: do not flag them, and never read `.env`.
4. **Private content.** No text from master section 6, `master/metrics-log.csv` (beyond evidenced numbers in their safe wording), `master/narrative-notes.md` or `master/archive.md`. A resume carries nothing from narrative notes; a cover letter may draw on them only rewritten, never verbatim. No NDA-restricted tool or client names beyond what master section 6 allows.
5. **Consistency.** Dates, titles, employers and tech stacks match the master. Overlapping dates are explainable per master section 6. A project stack in the resume matches the project entry (e.g. database names).
   Project entries must carry no dates or years (master section 4 rule). Flag any project date, except a work-in-progress marker the master supports.
6. **Leftovers.** No tag names, variant labels, or "(see Metrics Log)" notes.
7. **Length.** Estimate whether it fits one page; suggest what to cut if not.

Output: PASS or FAIL, then a numbered list of issues with the file line, the problem, and a suggested fix. Do not silently edit; propose changes unless the user asks you to apply them.

On PASS, run `bash scripts/set-status.sh <folder> verified`. On FAIL, leave the status unchanged. Never set `ready` or `exported`.
