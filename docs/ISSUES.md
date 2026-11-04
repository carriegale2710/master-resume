# Issues

Open problems found in the repo review. Tick when fixed.

## Ponytail audit (over-engineering), 2026-11-03

Ranked biggest cut first. Net: about -1300 lines, no deps to drop (pandoc only, needed).

- [x] yagni: `tailoring-rules/by-role/design.md` (238 lines) and `software-engineer.md` (96). Checklists far longer than `every-resume.md` (27). Trim to ticks that differ from the shared rules.
- [x] shrink: `scripts/tailor.sh` (162 lines). The `skill`/`desc`/`on` arrays and toggle loop drive only 2 steps (2, 3). Hardcode both and drop the checklist screen (about 25 lines).
- [x] shrink: `scripts/tailor.sh` back-navigation (`b N`, `jump`, `back` aliases, 1-6 validation) for a six-step linear flow. `q` plus re-run covers it (about 20 lines).
- [x] shrink: `scripts/build.sh` cover-letter branch. Three `$cover` conditionals plus a recursive self-call. Use a `--cover` flag or two small scripts.
- [x] shrink: `scripts/set-status.sh` `cover` arg and second status enum. Fold into one case on the column name.
- [x] shrink: `tests/test-docx-output-dir.sh` (33 lines). Fold into `test-docx-export.sh`.

## Out of scope (correctness)

- [x] `scripts/set-status.sh` and `scripts/build.sh` split CSV on plain commas. A quoted comma in `notes` shifts columns and can write status to the wrong field.
- [x] Cover-letter verify writes the resume `status` column. `verify-claims` runs `set-status.sh <folder> verified` without `cover`, and `tailor.sh` step 5 resets and reads `status`, so `cover_letter_status` never reaches `verified` and `build.sh` refuses the letter. Nothing sets `cover drafted` either, and `tailor.sh` passes only the folder, so `verify-claims` is not told which file to check.

## README check, 2026-11-04

Found by checking the README against `scripts/`, `.claude/skills/` and the spec.

- [ ] bug: `scripts/build.sh:59` sets `ready` before steps that can fail (missing `.env`, missing variable, no Pandoc). Line 54 accepts only `verified` or `exported`, so every rebuild is refused and `tailor.sh` step 6 cannot finish the row. Recovery: `bash scripts/set-status.sh <folder> verified`. Proposed fix: accept `ready` at line 54.
- [ ] noise: `scripts/build.sh:99` tries `cover-letter.md` whenever the file exists, and `new-application.sh` always creates it. An application with no letter prints `cover_letter_status is 'none', not verified.` and `Cover letter not exported.` Proposed fix: gate line 99 on status.
- [ ] gate: `skip` in `scripts/tailor.sh:40` sets `verified` without a pass, and `scripts/build.sh:54` checks status only. Recording each use is already in the spec's planned changes (`verify_skipped`).
- [ ] enforcement: `scripts/set-status.sh` accepts `ready` and `exported` from any caller, and `.claude/settings.json` denies only `Read(./.env)`. The "agents never set these" rule is written only. Decide whether to add a deny rule.
- [ ] history: `scripts/tailor.sh` never commits, and the only documented commit is at submit. A redraft overwrites an uncommitted `resume.md`.
- [ ] privacy decision: `carriegale2710` is in README plugin commands and `.claude/settings.json`, while README says links never live in the repo. `.env` was not read, so a match with `GITHUB_URL` is unconfirmed.
- [ ] stale: `CHANGELOG.md` says `templates/cover-letter-reference.docx` is not in the repo yet. It is tracked.
- [ ] open question: one Claude session per skill, or bundle skills in one session? See the spec's Risks & Open Questions.
- [x] README: corrected script details, gate wording, design decision reasons and the tracker column list.
