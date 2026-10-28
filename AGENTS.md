# Resume repo: agent rules

This file is the canonical, tool-neutral instruction set. Any agent working in this repo must follow it.

## Source of truth

- `master/master-resume.md` is the only source of facts. Never invent or infer a skill, tool, date, title, metric or outcome.
- Numbers are valid only if `master/master-resume.md` section 6 (metrics log) lists them. Rows marked **Estimate**, **Projection** or **Self-reported** must use the "safe wording" column unless the user says the evidence is ready.
- Anything marked `TODO` is unknown. Flag it; never fill it in.

## Privacy

- Never copy content from sections 6-10 of the master (metrics log, private notes, application log, archive) into a resume or cover letter.
- Respect the Outlier / Scale AI NDA note: use generic wording for tools and project types unless the user confirms otherwise.
- Never upload or paste this repo's private files into external services.
- Contact details are secret. Leave `${RESUME_NAME}`, `${RESUME_EMAIL}`, `${RESUME_PHONE}` and `${RESUME_LINKS}` placeholders exactly as written; they are intentional, not `TODO`. Never read `.env`, never ask for or write the real values, and never run the docx build (the user runs it locally so `.env` is filled in then).

## Writing rules

- Tailored resumes go in `applications/<YYYY-MM-company-role>/resume.md`. Never edit `master/` unless explicitly asked.
- Target one page: 5-7 strongest bullets per role family, older leadership items cut first.
- Mirror a job posting's keywords only where the master supports them.
- Plain, specific, past-tense bullets. No filler adjectives. Australian English spelling.
- Do not use tag names (`fullstack`, `qa`, etc.) in final output.

## Tools in this repo

- `bash scripts/build.sh --tags a,b --md-only master/master-resume.md` filters master bullets by tag.
- `bash scripts/build.sh applications/<folder>/resume.md` builds the .docx (user-run only; it fills the header from `.env`).
- `bash scripts/new-application.sh company-role` creates an application folder.
- Prefer these scripts over re-implementing their logic.

## Skills

Repo-specific skills live in `.claude/skills/<name>/SKILL.md`. Typical order for an application:

1. `tracker-intake`
2. `resume-tailor-quick`
3. `resume-ats-optimizer`
4. `verify-claims` (mandatory final step before any file is called ready)
5. `cover-letter-generator` (optional)
6. `interview-prep-generator` (after applying)

View `.claude/skills/README.md` for the full list of available other skills imported into this repo.

## Always report

At the end of any task, list: what was cut, what was reworded, and every claim that still needs evidence.

## Tracker status

`applications/tracker.csv` status moves `pending` (new-application.sh) -> `tailored` (resume-tailor-quick) -> `verified` (verify-claims, on PASS) -> `ready` (user runs `scripts/ready.sh`) -> `exported` (build.sh sets it after a docx build). Skills set their own status with `bash scripts/set-status.sh <folder> <status>` before finishing. The row `id` is the application folder name. Agents never set `ready` or `exported`.
