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
