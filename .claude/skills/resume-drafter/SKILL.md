---
name: resume-drafter
description: Draft a tailored resume (one page target, two pages maximum) from master/master-resume.md for a specific job posting in applications/<folder>/job-description.md. Use when asked to tailor, adapt, customise or write a resume for a role.
---

# Draft a tailored resume (one page target, two pages maximum)

Inputs: `master/master-resume.md`, `applications/<folder>/job-description.md`, `tailoring-rules/every-resume.md`, `templates/resume-template.md`, and only the `master/metrics-log.csv` rows behind numbers you use. Do not read `master/narrative-notes.md` or `master/archive.md`.

Read `tailoring-rules/every-resume.md` first. The draft must pass every item (one target role, headline states stack, what+how+why bullets, no generic Skills section, Education & Training placement, fully typed links). Report any item that fails or cannot be met from the master.

Then read the matching role checklist in `tailoring-rules/by-role/` (`software-engineer`, `qa-role`, `ai`, `design` or `retail-cs`) and, where they apply, `tailoring-rules/by-company/graduate.md`, `startup.md` and the relevant section of `industry.md`. Apply them under the universal checklist; where any conflicts with the source-of-truth or privacy rules in `AGENTS.md`, those rules win.

1. Read the job description. List required skills, tools, seniority and the role family (full-stack, frontend, QA, UX/accessibility, AI evaluation).
2. Pick the appropriate matching template if available.
3. Start with `bash scripts/build.sh --tags <tags matching the role> --md-only master/master-resume.md` instead of reading the whole master. It prints to stdout (no file written) master sections 0-5: headlines, summaries, main stack, education, work, projects and leadership. Tagged bullets appear only if they match a tag; untagged lines, including Stack, Role and Repo lines, stay. It drops section 6, all `> ` notes and the tag/variant keys.
4. Then read master section 6 (constraints) and the dropped notes (`grep -n '^> ' master/master-resume.md`). The notes hold entry rules and `TODO`s; ask about or flag any that affect a chosen entry.
5. From the filtered output choose the 5-7 strongest bullets overall, favouring bullets that match the posting's must-haves. Cut the rest.
6. Choose the bullet variant per `AGENTS.md`: use a quantified variant only if `master/metrics-log.csv` has a row for the number (find it with `grep -i '<claim>' master/metrics-log.csv`); otherwise use the safe wording.
7. Gaps: if a must-have has no master evidence, ask the user one open question about it (where, what they personally did, tools, scope). Never infer experience from uncertainty or turn exposure into proficiency. Anything they confirm goes into the master first via `improve-master` (with their permission), never straight into the resume. No defensible example: record the gap in the report and carry on.
8. Rewrite the summary in 2-3 lines using only facts from the master. Mirror the posting's exact phrasing only where it truthfully describes the work; no keyword stuffing.
9. Reorder sections, roles and bullets so the most relevant comes first. Remove tag names and private sections. Aim for one page; never exceed two. If it runs over one page, cut the least relevant bullets first.
10. Write to `applications/<folder>/resume.md`.
11. Run `bash scripts/set-status.sh <folder> tailored`.
12. Report: bullets cut, wording changed, claims needing evidence, gaps found, `TODO` fields still blank.

Do not add skills, tools or outcomes that are not in the master.

Project entries carry no dates or years (master section 4 rule). Dates belong on work experience and education only. Add a project date only for a work in progress, and only if the master gives it.
