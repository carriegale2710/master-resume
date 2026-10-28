# Resume repo

Private repo for my master resume and every tailored application.

**Goal (V1):** turn a job description into a verified, one-to-two page resume (and optionally a cover letter) in one sitting, using the scripts and skills here. No CLI, model API or database. Scope: [docs/MVP.md](docs/MVP.md). Longer-term target: [docs/PRODUCT-SPEC.md](docs/PRODUCT-SPEC.md). Where they differ, the MVP wins.

## Setup

`scripts/build.sh` needs the Pandoc executable (not the Python `pandoc` package). Install it from the [official instructions](https://pandoc.org/installing.html) and check `pandoc --version`. Run scripts with `bash scripts/<name>.sh`; on Windows use Git Bash.

To style the `.docx`, create `templates/reference.docx` with `pandoc -o templates/reference.docx --print-default-data-file reference.docx` and edit its styles in Word. `build.sh` uses it when present.

## Scripts

- `scripts/new-application.sh company-role`: creates `applications/<YYYY-MM>-company-role/` with `job-description.md`, `notes.md` and an empty `cover-letter.md`, and appends a `pending` row to `applications/tracker.csv`. Names allow ASCII letters, numbers and hyphens only; it refuses to overwrite a folder.
- `scripts/build.sh [--tags a,b] [--md-only] <input.md>`: filters bullets by tag, drops master sections 6-10, tag keys and blockquote notes, and warns if `TODO` remains. `--md-only` prints Markdown and never reads `.env`. Otherwise it fills the `${RESUME_*}` header from `.env`, writes `~/Downloads/<folder>-<name>.docx` (override with `RESUME_OUT_DIR`) and sets the tracker status to `exported`.
- `scripts/set-status.sh <folder> <status>`: sets `status` and `last_update` on the tracker row whose `id` is the folder name. Skills call it; `TRACKER` overrides the file.
- `scripts/ready.sh <folder>`: human-run approval; same as `set-status.sh <folder> ready`.

## Tests

Tests use synthetic data and never read the private master. GitHub Actions runs them on push and PR. Run from the repo root:

```bash
bash tests/run-all.sh
```

| Test | Purpose |
| --- | --- |
| `test-build.sh` | tag filtering, dropped sections 6-10, `TODO` warning, `.env` header fill, missing-value errors |
| `test-new-application.sh` | expected files, unsafe names rejected, duplicates refused, `pending` row added |
| `test-ready.sh` | `set-status.sh` and `ready.sh` update only the matching row; unknown statuses and missing rows rejected |
| `test-skill-evidence-rules.sh` | skill docs keep the evidence and privacy rules |
| `test-docx-export.sh` | real .docx from a synthetic resume; skips without Pandoc |
| `test-docx-output-dir.sh` | .docx lands in `$HOME/Downloads` by default; `RESUME_OUT_DIR` overrides; skips without Pandoc |

## Workflow

1. **Intake.** `bash scripts/new-application.sh acme-frontend`, then paste the posting into `applications/<folder>/job-description.md`.
2. **Tailor.** In an agent session run `tracker-intake`, `resume-tailor-quick`, then `resume-ats-optimizer`. The agent writes `resume.md` and never edits `master/`. Run `cover-letter-generator` only if a letter is needed. To draft by hand:
   `bash scripts/build.sh --tags frontend,a11y,fullstack --md-only master/master-resume.md > applications/<folder>/resume.md`
   then pick the 5-7 strongest bullets, mirror only keywords the master supports, and cut to one page.
3. **Verify.** Run `verify-claims`. Any unsupported claim, uncited claim or `TODO` blocks the next step.
4. **Approve.** `bash scripts/ready.sh <folder>`. The agent never sets `ready`. Editing a draft after approval means verifying again.
5. **Export.** Run the build yourself so `.env` fills the header:
   `bash scripts/build.sh applications/<folder>/resume.md`
6. **Submit.** `git add . && git commit -m "app: acme-frontend submitted" && git tag submit-YYYY-MM-acme`, then update the `tracker.csv` row.

Status flow: `pending` -> `tailored` -> `verified` -> `ready` (`ready.sh`) -> `exported` (`build.sh`). `tracker.csv` columns: `id, date_applied, company, role, location, source, version_folder, status, last_update, contact, outcome, notes, opening_date, closing_date, eligibility`.

Hard gates: zero unsupported claims in anything `ready`; metrics only from master section 6 using its safe wording; nothing from master sections 6-10 in output; one page target, two pages limit.

### Not built yet

- **Page-count check:** `build.sh` does not fail above two pages. Check the .docx manually.
- **`verify-report.md`:** `verify-claims` should write it; confirm its output before relying on it.

## Private header

Name, email, location, phone, links and work rights never live in the repo. Drafts use `${RESUME_NAME}`, `${RESUME_EMAIL}`, `${RESUME_LOCATION}`, `${RESUME_PHONE}`, `${RESUME_LINKS}` and `${RESUME_WORKRIGHTS}`. Put real values in a gitignored `.env` at the repo root (not `.env.example`, which holds sample resume content):

```
RESUME_NAME="Your Name"
RESUME_EMAIL="you@example.com"
RESUME_LOCATION="City, State"
RESUME_PHONE="04xx xxx xxx"
RESUME_LINKS="github.com/you | linkedin.com/in/you"
RESUME_WORKRIGHTS="Australian citizen"
```

The build substitutes them and fails if `.env` or a variable the draft uses is missing. Run it yourself, not through an agent. `.claude/settings.json` denies Claude's Read tool on `.env` (best effort; shell commands are a separate path).

## Tags

`fullstack` `backend` `frontend` `qa` `ux` `a11y` `ai-eval` `devops` `product` `leadership` `security`

## Rules and maintenance

- `master/master-resume.md` is the source of truth. Edit canonical files only in `master/`, `.claude/skills/` or `AGENTS.md`.
- One `applications/YYYY-MM-company-role/` folder per application; copy improved bullets to the master the same day.
- Log every number in section 6. Weekly: update master and metrics log. Monthly: check links. Quarterly: archive stale bullets.
- Master section references live in `AGENTS.md` and the skills; keep them in sync if sections move.
- Keep this repo **private**.

## Agents and skills

- `AGENTS.md` holds the canonical rules; `CLAUDE.md` points to it.
- `.claude/skills/` holds the skills as plain Markdown. Order: `tracker-intake`, `resume-tailor-quick`, `resume-ats-optimizer`, `verify-claims`, then optionally `cover-letter-generator` and `interview-prep-generator`.
- Tools without file access: paste `AGENTS.md` into the instructions and upload only the skill, master and job description needed. Never upload private notes to tools you do not control.

## Repository structure

```
master-resume/
├── README.md
├── AGENTS.md                      # canonical agent rules (edit this)
├── CLAUDE.md                      # one line: @AGENTS.md
├── .env.example                   # sample resume content, not env variables
├── .claude/settings.json          # denies Read on .env
├── .github/workflows/tests.yml
├── master/                        # master-resume.md, universal-checklist.md
├── industry/                      # design/ and dev/ tailoring guides
├── .claude/skills/                # README.md and <skill-name>/SKILL.md
├── templates/                     # dev.md, hybrid.md, design.md
├── scripts/                       # build.sh, new-application.sh, set-status.sh, ready.sh
├── tests/                         # test-*.sh, fixtures/dummy-resume.md
└── docs/                          # MVP.md, PRODUCT-SPEC.md
```
