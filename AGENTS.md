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

## Writing rules

- Tailored resumes go in `applications/<YYYY-MM-company-role>/resume.md`. Never edit `master/` unless explicitly asked.
- Target one page: 5-7 strongest bullets per role family, older leadership items cut first.
- Mirror a job posting's keywords only where the master supports them.
- Plain, specific, past-tense bullets. No filler adjectives. Australian English spelling.
- Do not use tag names (`fullstack`, `qa`, etc.) in final output.

## Tools in this repo

- `bash scripts/build.sh --tags a,b --md-only master/master-resume.md` filters master bullets by tag.
- `bash scripts/build.sh applications/<folder>/resume.md` builds the PDF.
- `bash scripts/new-application.sh company-role` creates an application folder.
- `bash scripts/link-skills.sh` links or copies skills for each tool.
- Prefer these scripts over re-implementing their logic.

## Skills

Repo-specific skills live in `skills/<name>/SKILL.md`. Typical order for an application:

1. `resume-tailor-quick`
2. `resume-ats-optimizer`
3. `verify-claims` (mandatory final step before any file is called ready)
4. `cover-letter-generator` (optional)
5. `interview-prep-generator` (after applying)

View `skills/README.md` for the full list of available other skills imported into this repo.

## Always report

At the end of any task, list: what was cut, what was reworded, and every claim that still needs evidence.
