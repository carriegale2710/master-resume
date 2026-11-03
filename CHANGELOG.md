# Changelog

Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/). No versions tagged yet.

## [Unreleased]

### Added

- Templates: `linkedin-profile.md`, `github-profile.md`, `project-case-study.md`, `portfolio-about-me.md`, `cold-email.md`, `follow-up-email.md`, `linkedin-dm.md`. Each carries the master source-of-truth, privacy and placeholder rules in a header comment.
- General application skills now come from the `job-application-agent` plugin; `AGENTS.md` maps its paths to this repo and wins on conflicts.

- `humanize-prose` skill strips AI patterns from cover letters.
- `humanize-prose` refuses `resume.md`; edits wording only, adds no facts.
- `build.sh` exports `cover-letter.md`: needs `cover_letter_status` `verified`, keeps line breaks, uses `templates/cover-letter-reference.docx` if present, else `templates/reference.docx`, leaves resume status alone.
- Word reference templates: `templates/reference.docx` (one-page resume, A4). Optional `templates/cover-letter-reference.docx` for letters; not in the repo yet.

### Changed

- `build.sh` accepts status `exported` and asks "Re-export? This will overwrite your previous export." before rebuilding.
- A resume build also offers the `cover-letter.md` in the same folder (own `verified` gate and y/N prompt).
- Cover letter build now sets `cover_letter_status` to `exported`; `set-status.sh <folder> exported cover` allows it. Resume status stays untouched.
- Renamed `templates/reference.docx` to `templates/resume-reference.docx`.
- `resume-orchestrator`, `tailor.sh` and docs call `job-application-agent:job-ad-decoder`, `application-lint`, `achievement-statements`, `cover-letter` and `interview-prep`.

- `AGENTS.md` order: cover letter, `humanize-prose`, then `verify-claims`.
- `design.md`, `software-engineer.md` cut to role-specific tick boxes.
- `set-status.sh`, `build.sh` now need gawk; CI installs it.
- `set-status.sh` prints `<column> <status>: <folder>`.
- `test-docx-output-dir.sh` folded into `test-docx-export.sh`.

### Removed

- `tailor.sh` `b N` back-navigation; quit with `q`, re-run instead.
- `tailor.sh` step 2/3 toggle checklist screen.
- `tailor.sh` "Replace existing JD?" prompt.

### Fixed

- `build.sh` keeps single line breaks in the `.docx`; the headline, contact line and education entries no longer merge into one paragraph.
- Quoted commas in `tracker.csv` no longer shift status columns.
- `tailor.sh` status read is quote-aware too; test 11 covers it.
- Cover-letter verify now checks `cover-letter.md` and uses `cover_letter_status` (reset to `drafted`, then `verified`), not the resume `status`. `build.sh` can now export a letter verified through `tailor.sh`.

## [0.1.0] - 2026-10-29

### Added

- `master/skills-inventory.csv` replaces master section 1 skills table.
- `master/metrics-log.csv`, `narrative-notes.md`, `archive.md` split from master.
- `tests/test-master-split.sh` checks side files; master ends section 6.

- `${RESUME_LOCATION}` and `${RESUME_WORKRIGHTS}` header placeholders. `build.sh` now requires only the variables a draft uses.
- `master/master-resume.md` single source of truth, merged from versions.
- Universal and role-specific CV checklists for design and software engineering.
- Sample job descriptions and templates, grouped by `industry` folders.
- Resume skills library under `.claude/skills/`.
- `scripts/build.sh` tag filter and build dox/pdf file.
- `scripts/new-application.sh` creates `applications/<folder>`.
- Shell tests for build and application scripts, synthetic data.
- `docs/PRODUCT-SPEC.md` with user flows.
- `applications/tracker.csv` row (`pending`) created by `new-application.sh`; new `id`, `opening_date` and `closing_date` columns.
- `scripts/set-status.sh` moves a row through `pending`, `tailored`, `verified`, `ready`, `exported`; `build.sh` requires `verified`, asks y/N approval (sets `ready`), then sets `exported` after a docx build; `resume-drafter` and `verify-claims` set their own status. `tests/test-set-status.sh` covers it.
- `tracker-intake` skill fills company, role, location, source and opening/closing dates from the job description.
- `tracker.csv` `eligibility` column, filled by `tracker-intake` from posting criteria.
- `tracker.csv` `EXAMPLE-` row shows what each column holds.
- `tracker.csv` `source` column holds original posting URL.
- `${RESUME_NAME}`, `${RESUME_EMAIL}`, `${RESUME_PHONE}` placeholders filled from `.env` at build.
- `${GITHUB_URL}`, `${LINKEDIN_URL}`, `${PORTFOLIO_URL}` header placeholders, filled from `.env`.
- Unset `*_URL` optional; build drops it plus `|`.

### Changed

- Resume skills follow evidence rules in `AGENTS.md`.
- Renamed `role` folder to `industry`.
- Contact details moved out of repo and agent view.
- Moved `skills/` to `.claude/skills/` so Claude Code loads skills directly; updated paths in docs and tests.
- Breaking: master sections 7-10 gone; docs and skills read side files.
- Universal checklist path now `checklists/universal-checklist.md`.
- `scripts/tailor.sh` now has 6 steps: new `resume-orchestrator` skill replaces the template, `resume-drafter` and `resume-ats-optimizer` steps and runs `verify-claims` itself; step 4 skips a row already `verified`.

- `scripts/build.sh` exports `.docx` via Pandoc only; `tests/test-docx-export.sh` replaces the PDF export test.

- `scripts/build.sh` saves the `.docx` to `~/Downloads/<folder>-<name>.docx` instead of the application folder; `RESUME_OUT_DIR` overrides. `tests/test-docx-output-dir.sh` covers it.

### Removed

- `scripts/link-skills.sh`, its test and CI step, no longer needed.
- PDF export (`--pdf`, WeasyPrint), `templates/style.css` and `tests/test-pdf-export.sh`.
- Breaking: `${RESUME_LINKS}` gone; old drafts print it literally.

### Fixed

- Shell tests failed on CRLF endings.
- `build.sh` pipefail hid SIGPIPE failures; TODO check remains.
- `new-application.sh` validates folder names and resolved paths.
- Build and PDF export regression tests expanded.
- `build.sh` strips every lowercase-kebab tag, not a fixed list.
- Docx tests use throwaway verified `TRACKER`; real tracker untouched.
