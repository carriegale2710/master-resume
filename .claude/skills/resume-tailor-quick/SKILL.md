---
name: resume-tailor-quick
description: Draft a tailored one-page resume from master/master-resume.md for a specific job posting in applications/<folder>/job-description.md. Use when asked to tailor, adapt, customise or write a resume for a role.
---

# Tailor resume

Inputs: `master/master-resume.md`, `applications/<folder>/job-description.md`, a template in `templates/` (dev, hybrid or design).

1. Read the job description. List required skills, tools, seniority and the role family (full-stack, frontend, QA, UX/accessibility, AI evaluation).
2. Pick the matching template. If unclear, choose hybrid and say so.
3. Run `bash scripts/build.sh --tags <relevant tags> --md-only master/master-resume.md` to get a filtered first draft.
4. From that draft choose the 5-7 strongest bullets overall, favouring bullets that match the posting's must-haves. Cut the rest.
5. Choose the bullet variant per `AGENTS.md`: use a quantified variant only if the metrics log supports the number; otherwise use the safe wording.
6. Rewrite the summary in 2-3 lines using only facts from the master.
7. Reorder sections so the most relevant comes first. Remove tag names and private sections.
8. Write to `applications/<folder>/resume.md`.
9. Run `bash scripts/set-status.sh <folder> tailored`.
10. Report: bullets cut, wording changed, claims needing evidence, `TODO` fields still blank.

Do not add skills, tools or outcomes that are not in the master.
