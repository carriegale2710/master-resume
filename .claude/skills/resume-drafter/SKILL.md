---
name: resume-drafter
description: Draft a tailored one-page resume from master/master-resume.md for a specific job posting in applications/<folder>/job-description.md. Use when asked to tailor, adapt, customise or write a resume for a role.
---

# Draft a tailored one-page resume

Inputs: `master/master-resume.md`, `applications/<folder>/job-description.md`, `master/universal-checklist.md`, a template in `templates/` (dev, hybrid or design).

Read `master/universal-checklist.md` first. The draft must pass every item (one target role, headline states stack, what+how+why bullets, no generic Skills section, Education & Training placement, fully typed links). Report any item that fails or cannot be met from the master.

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

Project entries carry no dates or years (master section 4 rule). Dates belong on work experience and education only. Add a project date only for a work in progress, and only if the master gives it.
