# Issues

Open problems found in the repo review (2026-11-02). Tick when fixed.

- [ ] **CI runs only 4 of 9 tests.** `.github/workflows/tests.yml` skips `test-set-status`, `test-tailor`, `test-master-split`, `test-agent-fixtures` and `test-docx-output-dir`. Fix: replace the separate test steps with `run: bash tests/run-all.sh` after the pandoc install.
- [x] **`.gitignore` ignores the docx templates.** `*.docx` matches `templates/reference.docx`, so a fresh clone or CI likely has no template and the build silently falls back to unstyled pandoc. Check with `git ls-files templates`. If missing, add `!templates/*.docx` to `.gitignore` and commit the templates.
- [ ] **Broken skill symlinks.** `.claude/skills/` holds symlinks (`obsidian-*`, `json-canvas`, `copilot-*`) into the gitignored `copilot/` folder, so they break on any clone. They are Obsidian tools, not resume tools. Fix: delete them from `.claude/skills/`.
- [x] **Stale paths in the master.** The note at the top of `master-resume/master-resume.md` points to `checklists/universal-checklist.md` and `master/metrics-log.csv`, which no longer exist. Agents follow these notes. Fix: change them to `tailoring/every-resume.md` and `master-resume/metrics-log.csv`.
- [ ] **`verify-report.md` contradiction.** `docs/MVP.md` marks it done, the README says "not built yet", and the `verify-claims` skill never writes a file. Fix: either make `verify-claims` write `applications/<folder>/verify-report.md`, or remove it from the MVP done-when list and the README.
