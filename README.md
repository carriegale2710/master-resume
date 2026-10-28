# Resume repo

Private repo for my master resume and every tailored application.

**Goal (V1):** turn a job description into a verified, one-to-two page resume (and optionally a cover letter) in one sitting, using the scripts and skills here. No CLI, model API or database. See [docs/MVP.md](docs/MVP.md) for the scope and [docs/PRODUCT-SPEC.md](docs/PRODUCT-SPEC.md) for the longer-term target. Where they differ, the MVP wins.

## Requirements

The PDF build in `scripts/build.sh` requires both the Pandoc executable and the
WeasyPrint executable. Pandoc converts Markdown to HTML; WeasyPrint renders the
HTML and CSS to PDF.

## Setup

1. Install Pandoc using the [official installation instructions](https://pandoc.org/installing.html).
   The Python package named `pandoc` is not a substitute for the Pandoc executable.
2. Install WeasyPrint and any operating-system dependencies it needs, following
   the [official installation instructions](https://doc.courtbouillon.org/weasyprint/stable/first_steps.html#installation).
   For Python environments, WeasyPrint can be installed with:

```bash
python -m pip install weasyprint
```

3. Check that both executables are available on your `PATH`:

```bash
pandoc --version
weasyprint --version
```

The PDF build will fail if either command is unavailable. You can run scripts
with Bash without changing their executable permissions:

```bash
bash scripts/build.sh applications/<folder>/resume.md
```

## How to use the scripts

The scripts in this repository help automate the process of creating tailored resumes, building PDFs, and managing skills. Here's a brief overview:

- `scripts/new-application.sh company-role`: Creates `applications/<YYYY-MM>-company-role/` containing `job-description.md`, `notes.md` and an empty `cover-letter.md`. Names allow ASCII letters, numbers and hyphens only; it refuses to overwrite an existing folder.
- `scripts/build.sh [--tags a,b] [--md-only] <input.md>`: Filters bullets by tag, always drops master sections 6-10, tag keys and blockquote notes, and warns if `TODO` remains. `--md-only` prints Markdown to stdout and never reads `.env`. Without it, the script fills the `${RESUME_*}` header from `.env` and writes `<input>.pdf` via Pandoc and WeasyPrint.

## Tests

The build, application-generator, and PDF-export tests use synthetic resume data; none of the tests read the private master resume. GitHub Actions runs the tests on pushes and pull requests. The PDF-export test runs when Pandoc and WeasyPrint are installed and otherwise reports a skip. To run the tests locally from the repository root with Bash:

```bash
bash tests/test-build.sh
bash tests/test-new-application.sh
bash tests/test-skill-evidence-rules.sh
bash tests/test-pdf-export.sh
```

| Test | Purpose |
| --- | --- |
| `test-build.sh` | `scripts/build.sh`: tag filtering, dropped sections 6-10, `TODO` warning, `.env` header fill and missing-value errors |
| `test-new-application.sh` | `scripts/new-application.sh`: creates the expected files, rejects unsafe names and paths outside `applications/`, refuses duplicates |
| `test-skill-evidence-rules.sh` | Skill docs keep the evidence and privacy rules (metrics, cover letter, ATS) |
| `test-pdf-export.sh` | Real PDF output from a synthetic resume; skips if Pandoc or WeasyPrint is missing |

For a manual PDF-export check when those dependencies are available, create a synthetic input and verify the resulting file:

```bash
tmp_dir="$(mktemp -d)"
printf '# Synthetic PDF check\n\nPDF export works.\n' > "$tmp_dir/check.md"
bash scripts/build.sh "$tmp_dir/check.md"
test -s "$tmp_dir/check.pdf"
head -c 5 "$tmp_dir/check.pdf" | grep -q '%PDF-'
rm -rf "$tmp_dir"
```

On Windows, run these commands from Git Bash.

## Workflow

1. **Intake.** `bash scripts/new-application.sh acme-frontend`, then paste the posting into `applications/<folder>/job-description.md`.
2. **Tailor.** In an agent session, run `resume-tailor-quick`, then `resume-ats-optimizer`. The agent writes `resume.md` in the application folder and never edits `master/`. Run `cover-letter-generator` only if the job needs a letter. To draft by hand instead:
   `bash scripts/build.sh --tags frontend,a11y,fullstack --md-only master/master-resume.md > applications/<folder>/resume.md`
   then pick the 5-7 strongest bullets, mirror only keywords the master supports, and cut to one page.
3. **Verify.** Run `verify-claims`. Check that each claim cites a master line. Any unsupported claim, uncited claim or `TODO` blocks the next step.
4. **Approve.** After a clean verify, set the application's `status` to `ready` in `tracker.csv` by hand. The agent never sets `ready`. Editing a draft after approval means verifying again.
5. **Export.** Run the PDF build yourself so `.env` fills the contact header:
   `bash scripts/build.sh applications/<folder>/resume.md`
6. **Submit.** Commit and tag:
   `git add . && git commit -m "app: acme-frontend submitted" && git tag submit-YYYY-MM-acme`, then update the `tracker.csv` row.

Hard gates: zero unsupported claims in anything `ready`; metrics only from master section 6 using its safe wording; nothing from master sections 6-10 in output; one page is the target, two is the limit.

### Not built yet (MVP checklist)

- **Page-count check:** `build.sh` does not yet fail above two pages. Check the PDF manually until it does.
- **`verify-report.md`:** the `verify-claims` skill is meant to write this file; confirm its output before relying on it.
- **`ready` helper script:** optional; edit `tracker.csv` by hand for now.

`tracker.csv` columns: `date_applied, company, role, location, source, version_folder, status, last_update, contact, outcome, notes`.

## Private header (contact details)

Name, email, phone and links never live in the repo. Drafts use the placeholders `${RESUME_NAME}`, `${RESUME_EMAIL}`, `${RESUME_PHONE}` and `${RESUME_LINKS}`. Put the real values in a gitignored `.env` at the repo root (not `.env.example`, which holds sample resume content):

```
RESUME_NAME="Your Name"
RESUME_EMAIL="you@example.com"
RESUME_PHONE="04xx xxx xxx"
RESUME_LINKS="github.com/you | linkedin.com/in/you"
```

`bash scripts/build.sh applications/<folder>/resume.md` substitutes them at PDF time and fails if `.env` or a variable is missing. `--md-only` never reads `.env`. Run the PDF build yourself, not through an agent. `.claude/settings.json` denies Claude's Read tool on `.env`; that is best effort, since shell commands are a separate path.

## Tags

`fullstack` `backend` `frontend` `qa` `ux` `a11y` `ai-eval` `devops` `product` `leadership` `security`

## Rules and maintenance

- Treat `master/master-resume.md` as the source of truth; edit canonical files only in `master/`, `.claude/skills/` or `AGENTS.md`.
- Use one `applications/YYYY-MM-company-role/` folder per application; copy improved bullets to the master the same day.
- Log every number in section 6. Weekly, update the master and metrics log; monthly, check links; quarterly, archive stale bullets.
- Keep this repo **private**.

## Things to know

- **Applications:** `new-application.sh` creates the `applications/` directory and each application folder as needed.
- **Master sections:** Section references are documented in `AGENTS.md` and the relevant skills. Keep them in sync if sections move.

## Agents and skills

- `AGENTS.md` holds the canonical rules. `CLAUDE.md` points to it.
- `.claude/skills/` holds the canonical skills as plain Markdown.
- Tools without file access: paste `AGENTS.md` into the instructions and upload only the skill, master and job description needed. Never upload private notes to tools you do not control.
- Typical order of use: `resume-tailor-quick`, `resume-ats-optimizer`, `verify-claims`, then optionally `cover-letter-generator` and `interview-prep-generator`.

## Repository Tree Structure

This is the tracked repository structure. Application folders are created when needed.

```
master-resume/
├── README.md                      # workflow and setup
├── AGENTS.md                      # canonical agent rules (edit this)
├── CLAUDE.md                      # one line: @AGENTS.md
├── tracker.csv                    # application log and status (`ready` is set by hand)
├── .env.example                   # sample resume content in Markdown, not environment variables
├── .gitignore                     # ignores .env
├── .claude/settings.json          # denies Claude's Read tool on .env
├── .github/workflows/tests.yml    # runs the shell tests on push and PR
│
├── master/
│   ├── master-resume.md
│   └── universal-checklist.md
│
├── industry/                      # industry-specific resume tailoring guides + templates
│   ├── design/
│   └── dev/
│
├── .claude/skills/                # skills (edit these)
│   ├── README.md
│   └── <skill-name>/SKILL.md
│
├── templates/
│   ├── dev.md
│   ├── hybrid.md
│   ├── design.md
│   └── style.css                  # PDF stylesheet
│
├── scripts/
│   ├── build.sh                   # tag filter and PDF export
│   └── new-application.sh         # creates an application folder
├── tests/
│   ├── fixtures/
│   │   └── dummy-resume.md        # synthetic input for build.sh tests
│   ├── test-build.sh              # tests tag filtering and private-section removal
│   ├── test-new-application.sh    # tests application-folder creation
│   ├── test-skill-evidence-rules.sh # checks skills keep the evidence rules
│   └── test-pdf-export.sh         # checks PDF export when dependencies are available
│
└── docs/
    ├── MVP.md                     # V1 scope and build checklist
    ├── PRODUCT-SPEC.md            # longer-term target
    └── CHANGELOG.md
```
