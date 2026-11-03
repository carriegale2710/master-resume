# Resume repo

Private repo for my master resume and every tailored application.

**Goal (V1):** turn a job description into a verified, one-to-two page resume (and optionally a cover letter) in one sitting, using the scripts and skills here. No CLI, model API or database. Longer-term target: [docs/PRODUCT-SPEC.md](docs/PRODUCT-SPEC.md); V1 is what the scripts and skills here already do.

## Setup

`scripts/build.sh` needs the Pandoc executable (not the Python `pandoc` package). Install it from the [official instructions](https://pandoc.org/installing.html) and check `pandoc --version`. Run scripts with `bash scripts/<name>.sh`; on Windows use Git Bash.

The `job-application-agent` plugin is enabled for this project only (`.claude/settings.json`). To install it on a new machine, run from the repo root: `claude plugin marketplace add carriegale2710/job-application-agent --scope project`, then `claude plugin install job-application-agent@job-application-agent --scope project`. Its skills load only in sessions started in this repo; restart the session or run `/reload-plugins` after installing.

`.docx` styling comes from Word reference templates: `templates/resume-reference.docx` (resume: A4, 1.5 cm margins, Calibri 10 pt, navy ruled section headings) and an optional `templates/cover-letter-reference.docx` for letters (not in the repo yet). Pandoc takes only their styles, page size, margins and headers/footers, never their body content. To change the look, open one in Word, modify the styles it uses (Heading 1 = name, Heading 2 = section, Body Text, First Paragraph, Compact = list items, Hyperlink) and save.

## Scripts

- `scripts/new-application.sh company-role`: creates `applications/<YYYY-MM>-company-role/` with `job-description.md`, `notes.md` and an empty `cover-letter.md`, and appends a `pending` row to `applications/tracker.csv`. Names allow ASCII letters, numbers and hyphens only; it refuses to overwrite a folder.
- `scripts/build.sh [--tags a,b] [--md-only] <input.md>`: filters bullets by tag, drops master section 6 (and any later section), tag keys and blockquote notes, and warns if `TODO` remains. `--md-only` prints Markdown and never reads `.env`. Otherwise it requires tracker status `verified`, asks `Approve and build docx? [y/N]` (yes sets `ready`), fills the `${RESUME_*}` header from `.env`, writes `~/Downloads/<folder>-<name>.docx` (override with `RESUME_OUT_DIR`) and sets the tracker status to `exported`. For `cover-letter.md` it requires `cover_letter_status` `verified` instead, keeps each line on its own line, and leaves `status` unchanged.
- `scripts/set-status.sh <folder> <status>`: sets `status` and `last_update` on the tracker row whose `id` is the folder name. Skills call it; `TRACKER` overrides the file.

## Tests

Tests use synthetic data and never read the private master. GitHub Actions runs them on push and PR. Run from the repo root:

```bash
bash tests/run-all.sh
```

| Test                           | Purpose                                                                                           |
| ------------------------------ | ------------------------------------------------------------------------------------------------- |
| `test-build.sh`                | tag filtering, dropped private sections, `TODO` warning, `.env` header fill, missing-value errors |
| `test-master-split.sh`         | master stops at section 6; metrics log, skills inventory, narrative notes and archive files exist |
| `test-new-application.sh`      | expected files, unsafe names rejected, duplicates refused, `pending` row added                    |
| `test-set-status.sh`           | `set-status.sh` updates only the matching row; unknown statuses and missing rows rejected         |
| `test-docx-export.sh`          | real .docx from a synthetic resume; skips without Pandoc                                          |
| `test-tailor.sh`               | `tailor.sh` flow with a stub `claude`: JD capture, step order, verify loop and `skip`, export     |
| `test-agent-fixtures.sh`       | runs the tailor skill on a temp copy with the dummy master; skips without the `claude` CLI        |

## Workflow

1. **Intake.** `bash scripts/new-application.sh acme-frontend`, then paste the posting into `applications/<folder>/job-description.md`.
   Or run `bash scripts/tailor.sh` (no arguments) to do steps 1-3 interactively in 6 steps: it asks for the company, role, URL, posting and closing date, then opens one Claude session per skill, loops `verify-claims` until it passes, offers a cover letter, then at step 6 Enter runs `build.sh` (with its own y/N approval) and the CLI exits once the row is `exported` (`c` re-checks status without building). Every prompt takes `q` (quit). Pick an existing folder by number to resume.
2. **Tailor.** In an agent session run `tracker-intake`, then `resume-orchestrator` (it analyses the posting, drafts with `resume-drafter`, reviews with `job-application-agent:application-lint` and pulls in other plugin skills as needed). The agent writes `resume.md` and never edits `master/`. Run `job-application-agent:cover-letter` only if a letter is needed. To draft by hand:
   `bash scripts/build.sh --tags frontend,a11y,fullstack --md-only master/master-resume.md > applications/<folder>/resume.md`
   then pick the 5-7 strongest bullets, mirror only keywords the master supports, and cut to one page (two pages maximum).
3. **Verify.** Run `verify-claims`. Any unsupported claim, uncited claim or `TODO` blocks the next step.
4. **Approve and export.** Run the build yourself so `.env` fills the header; answer `y` at the prompt to approve:
   `bash scripts/build.sh applications/<folder>/resume.md`
   The agent never sets `ready`. Editing a draft after verify means verifying again.
5. **Submit.** `git add . && git commit -m "app: acme-frontend submitted" && git tag submit-YYYY-MM-acme`, then update the `tracker.csv` row.

Status flow: `pending` -> `tailored` -> `verified` -> `ready` -> `exported` (both set by `build.sh` after your y/N approval). Building an `exported` resume asks "Re-export?" before overwriting. A resume build then offers the `cover-letter.md` beside it; its own `cover_letter_status` goes `none` -> `drafted` -> `verified` -> `exported`. `tracker.csv` columns: `id, date_applied, company, role, location, source, version_folder, status, last_update, contact, outcome, notes, opening_date, closing_date, eligibility`.

Hard gates: zero unsupported claims in anything `ready`; metrics only from `master/metrics-log.csv` using its safe wording; nothing from master section 6, `master/narrative-notes.md` or `master/archive.md` in output; one page target, two pages limit.

### Not built yet

- **Page-count check:** `build.sh` does not fail above two pages. Check the .docx manually.

## Private header

Name, email, location, phone, links and work rights never live in the repo. Drafts use `${RESUME_NAME}`, `${RESUME_EMAIL}`, `${RESUME_LOCATION}`, `${RESUME_PHONE}`, `${RESUME_WORKRIGHTS}`, `${GITHUB_URL}`, `${LINKEDIN_URL}` and `${PORTFOLIO_URL}`. Copy `.env.example` to a gitignored `.env` at the repo root and put your real values in `.env` (never in `.env.example`):

```
RESUME_NAME="Your Name"
RESUME_EMAIL="you@example.com"
RESUME_LOCATION="City, State"
RESUME_PHONE="04xx xxx xxx"
RESUME_WORKRIGHTS="Australian citizen"
GITHUB_URL="github.com/you"
LINKEDIN_URL="linkedin.com/in/you"
PORTFOLIO_URL="yourportfolio.com"
```

The build substitutes them and fails if `.env` or a variable the draft uses is missing. The three `*_URL` values are optional: an unset one is dropped along with its `|` separator. Run it yourself, not through an agent. `.claude/settings.json` denies Claude's Read tool on `.env` (best effort; shell commands are a separate path).

## Tags

`fullstack` `backend` `frontend` `qa` `ux` `a11y` `ai-eval` `devops` `product` `leadership` `security` `research` `ecommerce` `startup` `retail` `customer-service`

Summary-variant and add-on tags, and what each tag covers, live in `master/tags.md`.

## Rules and maintenance

- `master/master-resume.md` is the source of truth. Edit canonical files only in `master/`, `.claude/skills/` or `AGENTS.md`.
- One `applications/YYYY-MM-company-role/` folder per application; copy improved bullets to the master the same day.
- Log every number in `master/metrics-log.csv`. Weekly: update master and metrics log. Monthly: check links. Quarterly: move stale bullets to `master/archive.md`.
- Master section references live in `AGENTS.md` and the skills; keep them in sync if sections move.
- Keep this repo **private**.

## Agents and skills

- `AGENTS.md` holds the canonical rules; `CLAUDE.md` points to it.
- `.claude/skills/` holds the skills as plain Markdown. Order: `tracker-intake`, `resume-orchestrator`, `verify-claims`, then optionally `job-application-agent:cover-letter` and `job-application-agent:interview-prep`. General application skills come from the [`job-application-agent`](https://github.com/carriegale2710/job-application-agent) plugin; `AGENTS.md` maps its paths to this repo.
- Tools without file access: paste `AGENTS.md` into the instructions and upload only the skill, master and job description needed. Never upload `master/metrics-log.csv`, `master/narrative-notes.md` or `master/archive.md` to tools you do not control.

## Repository structure

```
master-resume/
├── README.md
├── AGENTS.md                      # canonical agent rules (edit this)
├── CLAUDE.md                      # one line: @AGENTS.md
├── ISSUES.md                      # open repo issues
├── .env.example                   # placeholder header values; copy to .env
├── .claude/
│   ├── settings.json              # denies Read on .env
│   └── skills/                    # <skill-name>/SKILL.md
├── .github/workflows/tests.yml
├── applications/                  # tracker.csv, archive/, one YYYY-MM-company-role/ folder per application
├── master/                        # master-resume.md, metrics-log.csv, skills-inventory.csv, narrative-notes.md, archive.md, tags.md
├── tailoring-rules/               # every-resume.md, by-role/ and by-company/ checklists
├── templates/                     # resume, cover letter, emails, LinkedIn/GitHub profile, case study, about me; *-reference.docx (Word styles)
├── examples/                      # job-desc-samples/
├── scripts/                       # build.sh, new-application.sh, set-status.sh, tailor.sh
├── tests/                         # run-all.sh, test-*.sh, fixtures/ (dummy master, side files, resume, sample application)
└── docs/                          # PRODUCT-SPEC.md, research/
```

Local only (gitignored): `.env`, `TODO.md`, `copilot/`, `.copilot/`, `.obsidian/`.
