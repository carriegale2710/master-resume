---
name: verify-claims
description: Audit a tailored resume or cover letter for unsupported numbers, estimates presented as facts, leaked private content, TODO placeholders and inconsistencies against the master. Mandatory final step before an application is called ready.
---

# Verify claims

Inputs: the file to check, `master/master-resume.md` (especially section 6 metrics log and section 7 private notes).

Check, in order:
1. **Numbers.** Every number, percentage and count must match a metrics-log row. Classify each as Fact, Estimate, Projection, Self-reported or Unlisted.
2. **Unsafe claims.** Estimates, projections and unlisted numbers must use the log's safe wording, or be flagged for the user to supply evidence.
3. **TODO.** Any remaining `TODO` or missing contact/link must be listed.
4. **Private content.** No text from sections 6-10 of the master. No NDA-restricted tool or client names beyond what the private notes allow.
5. **Consistency.** Dates, titles, employers and tech stacks match the master. Overlapping dates are explainable per the private notes. A project stack in the resume matches the project entry (e.g. database names).
6. **Leftovers.** No tag names, variant labels, or "(see Metrics Log)" notes.
7. **Length.** Estimate whether it fits one page; suggest what to cut if not.

Output: PASS or FAIL, then a numbered list of issues with the file line, the problem, and a suggested fix. Do not silently edit; propose changes unless the user asks you to apply them.
