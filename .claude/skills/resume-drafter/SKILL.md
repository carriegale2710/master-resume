---
name: resume-drafter
description: Draft a tailored one-page resume from master/master-resume.md for a specific job posting in applications/<folder>/job-description.md. Use when asked to tailor, adapt, customise or write a resume for a role.
---

# Draft a tailored one-page resume

Inputs: `master/master-resume.md`, `applications/<folder>/job-description.md`, `checklists/universal-checklist.md`, a template in `templates/` (dev, hybrid or design), and only the `master/metrics-log.csv` rows behind numbers you use. Do not read `master/narrative-notes.md` or `master/archive.md`.

Read `checklists/universal-checklist.md` first. The draft must pass every item (one target role, headline states stack, what+how+why bullets, no generic Skills section, Education & Training placement, fully typed links). Report any item that fails or cannot be met from the master.

1. Read the job description. List required skills, tools, seniority and the role family (full-stack, frontend, QA, UX/accessibility, AI evaluation).
2. Pick the matching template. If unclear, choose hybrid and say so.
3. Start with `bash scripts/build.sh --tags <tags matching the role> --md-only master/master-resume.md` instead of reading the whole master. It prints to stdout (no file written) master sections 0-5: headlines, summaries, main stack, education, work, projects and leadership. Tagged bullets appear only if they match a tag; untagged lines, including Stack, Role and Repo lines, stay. It drops section 6, all `> ` notes and the tag/variant keys.
4. Then read master section 6 (constraints) and the dropped notes (`grep -n '^> ' master/master-resume.md`). The notes hold entry rules and `TODO`s; ask about or flag any that affect a chosen entry.
5. From the filtered output choose the 5-7 strongest bullets overall, favouring bullets that match the posting's must-haves. Cut the rest.
6. Choose the bullet variant per `AGENTS.md`: use a quantified variant only if `master/metrics-log.csv` has a row for the number (find it with `grep -i '<claim>' master/metrics-log.csv`); otherwise use the safe wording.
7. Rewrite the summary in 2-3 lines using only facts from the master.
8. Reorder sections so the most relevant comes first. Remove tag names and private sections.
9. Write to `applications/<folder>/resume.md`.
10. Run `bash scripts/set-status.sh <folder> tailored`.
11. Report: bullets cut, wording changed, claims needing evidence, `TODO` fields still blank.

Do not add skills, tools or outcomes that are not in the master.

Project entries carry no dates or years (master section 4 rule). Dates belong on work experience and education only. Add a project date only for a work in progress, and only if the master gives it.
