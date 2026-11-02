# Resume repo: agent rules

This file is the canonical, tool-neutral instruction set. Any agent working in this repo must follow it.

## Source of truth

- `master/master-resume.md` is the only source of facts. Never invent or infer a skill, tool, date, title, metric or outcome.
- Numbers are valid only if `master/metrics-log.csv` lists them. Rows marked **Estimate**, **Projection** or **Self-reported** must use the "Safe wording" column unless the user says the evidence is ready.
- Skills reference: `master/skills-inventory.csv` (Strong, Proficient, Weak / exposure only). Never lead with Weak / exposure only. A skill no master bullet evidences is a `TODO`.
- Anything marked `TODO` is unknown. Flag it; never fill it in.

## Privacy

- Never copy content from master section 6 (private constraints), `master/metrics-log.csv` (numbers only as evidenced, worded per "Safe wording"), `master/narrative-notes.md` (may inform cover letters and interview prep, rewritten; never a resume) or `master/archive.md` into a resume or cover letter.
- Respect the Outlier / Scale AI NDA note: use generic wording for tools and project types unless the user confirms otherwise.
- Never upload or paste this repo's private files into external services.
- Contact details are secret. Leave `${RESUME_NAME}`, `${RESUME_EMAIL}`, `${RESUME_LOCATION}`, `${RESUME_PHONE}`, `${RESUME_WORKRIGHTS}`, `${GITHUB_URL}`, `${LINKEDIN_URL}` and `${PORTFOLIO_URL}` placeholders exactly as written; they are intentional, not `TODO`. Never read `.env`, never ask for or write the real values, and never run the docx build (the user runs it locally so `.env` is filled in then).

## Writing rules

- Tailored resumes go in `applications/<YYYY-MM-company-role>/resume.md`. Never edit `master/` unless explicitly asked.
- Target one page: 5-7 strongest bullets per role family, older leadership items cut first.
- Mirror a job posting's keywords only where the master supports them.
- Plain, specific, past-tense bullets. No filler adjectives. Australian English spelling.
- Do not use tag names (`fullstack`, `qa`, etc.) in final output.
- Projects carry no dates or years (master section 4 rule). Add one only for a work in progress, and only if the master gives it. Never ask for or invent project or deployment dates.
- Tailoring workflow: follow `tailoring-rules/every-resume.md` (one target role, headline states stack, what+how+why bullets, no generic Skills section, graduate roles put Education & Training under the summary, fully typed links), then the matching role checklist in `tailoring-rules/by-role/` and, where they apply, `tailoring-rules/by-company/graduate.md`, `startup.md` and `industry.md`. Tick every item before calling a resume tailored. Where it conflicts with the privacy or source-of-truth rules above, those rules win.

## Tools in this repo

- `bash scripts/build.sh --tags a,b --md-only master/master-resume.md` filters master bullets by tag.
- `bash scripts/build.sh applications/<folder>/resume.md` builds the .docx (user-run only; it fills the header from `.env`).
- `bash scripts/new-application.sh company-role` creates an application folder.
- `bash scripts/tailor.sh` runs the whole tailoring flow interactively (user-run only; it opens Claude sessions and its last step runs the docx build, so agents never run it).
- Prefer these scripts over re-implementing their logic.

## Skills

Repo-specific skills live in `.claude/skills/<name>/SKILL.md`. Typical order for an application:

1. `tracker-intake`
2. `resume-orchestrator` (runs `job-description-analyzer`, `resume-drafter`, `resume-ats-optimizer`, and other `resume-*` skills as needed, then `verify-claims`)
3. `verify-claims` (mandatory final step before any file is called ready)
4. `cover-letter-generator` (optional), then `humanize-prose` on the letter (never on the resume), then `verify-claims` on the letter
5. `interview-prep-generator` (after applying)

View `.claude/skills/README.md` for the full list of available other skills imported into this repo.

## Always report

At the end of any task, list: what was cut, what was reworded, and every claim that still needs evidence.

## Tracker status

`applications/tracker.csv` status moves `pending` (new-application.sh) -> `tailored` (resume-drafter) -> `verified` (verify-claims, on PASS) -> `ready` (build.sh sets it when the user answers y at its approval prompt) -> `exported` (build.sh sets it after a docx build). Skills set their own status with `bash scripts/set-status.sh <folder> <status>` before finishing. The row `id` is the application folder name. Agents never set `ready` or `exported`.
