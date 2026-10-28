# Changelog

Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/). No versions tagged yet.

## [Unreleased] - 2026-10-28

### Added

- `master/master-resume.md` single source of truth, merged from versions.
- Universal and role-specific CV checklists for design and software engineering.
- Sample job descriptions and templates, grouped by `industry` folders.
- Resume skills library under `.claude/skills/`.
- `scripts/build.sh` tag filter and build dox/pdf file.
- `scripts/new-application.sh` creates `applications/<folder>`.
- Shell tests for build and application scripts, synthetic data.
- `docs/PRODUCT-SPEC.md` with user flows.
- `${RESUME_NAME}`, `${RESUME_EMAIL}`, `${RESUME_PHONE}`, `${RESUME_LINKS}` placeholders filled from `.env` at build.

### Changed

- Resume skills follow evidence rules in `AGENTS.md`.
- Renamed `role` folder to `industry`.
- Contact details moved out of repo and agent view.
- Moved `skills/` to `.claude/skills/` so Claude Code loads skills directly; updated paths in docs and tests.

- `scripts/build.sh` exports `.docx` via Pandoc only; `tests/test-docx-export.sh` replaces the PDF export test.

- `scripts/build.sh` saves the `.docx` to `~/Downloads/<folder>-<name>.docx` instead of the application folder; `RESUME_OUT_DIR` overrides. `tests/test-docx-output-dir.sh` covers it.

### Removed

- `scripts/link-skills.sh`, its test and CI step, no longer needed.
- PDF export (`--pdf`, WeasyPrint), `templates/style.css` and `tests/test-pdf-export.sh`.

### Fixed

- Shell tests failed on CRLF endings.
- `build.sh` pipefail hid SIGPIPE failures; TODO check remains.
- `new-application.sh` validates folder names and resolved paths.
- Build and PDF export regression tests expanded.
