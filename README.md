# Resume repo

Private repo for my master resume and every tailored application.

## Requirements

- `pandoc` (required) -> used for converting Markdown to PDF
- `weasyprint` (PDF engine) -> used for rendering PDFs from HTML/CSS

## Setup

1. Install the required dependencies:

```bash
pip install pandoc weasyprint
```

2. Run this once.

```bash
chmod +x scripts/*.sh
```

This marks every `.sh` file in `scripts/` as executable on Unix-like systems. You can run scripts directly, like:

```bash
./scripts/build.sh
```

## How to use the scripts

The scripts in this repository help automate the process of creating tailored resumes, building PDFs, and managing skills. Here's a brief overview:

- `scripts/new-application.sh <folder>`: Creates a new application folder with the necessary files.
- `scripts/build.sh [options] <input>`: Builds a resume or cover letter. Use `--tags` to filter bullets by tags and `--md-only` to output only Markdown.
- `scripts/link-skills.sh [--copy]`: Links or copies skills from the `skills/` directory to the tool-specific directories. Use `--copy` if the tool does not follow symlinks.

## Workflow

1. Create the application folder:
   `./scripts/new-application.sh acme-frontend`
2. Paste the job posting into `job-description.md`.
3. Draft a starting resume filtered by tags:
   `./scripts/build.sh --tags frontend,a11y,fullstack --md-only master/master-resume.md > applications/<folder>/resume.md`
4. Edit `resume.md` by hand: pick the 5-7 strongest bullets, mirror true keywords from the posting, reword the summary, cut to one page.
5. Export to PDF:
   `./scripts/build.sh applications/<folder>/resume.md`
6. Submit, then commit and tag:
   `git add . && git commit -m "app: acme-frontend submitted" && git tag submit-YYYY-MM-acme`
7. Add a row to `tracker.csv`.

## Tags

`fullstack` `backend` `frontend` `qa` `ux` `a11y` `ai-eval` `devops` `product` `leadership` `security`

## Rules and maintenance

- Treat `master/master-resume.md` as the source of truth; edit canonical files only in `master/`, `skills/` or `AGENTS.md`.
- Use one `applications/YYYY-MM-company-role/` folder per application; copy improved bullets to the master the same day.
- Log every number in section 6. Weekly, update the master and metrics log; monthly, check links; quarterly, archive stale bullets.
- Keep this repo **private**.

## Things to know

- **Skill links:** `.claude/` and `.codex/` are created by `bash scripts/link-skills.sh`. Symlinks can be committed; ignore copied folders to avoid stale duplicates.
- **Applications:** `applications/` starts empty; `new-application.sh` creates each application folder.
- **Master sections:** The metrics log and private notes are sections 6 and 7, referenced by section in `AGENTS.md` and `verify-claims`. Update those references if you move either section.

## Agents and skills (tool-neutral)

- `AGENTS.md` holds the canonical rules. `CLAUDE.md` and `GEMINI.md` only point to it.
- `skills/` holds the canonical skills as plain Markdown.
- Run `bash scripts/link-skills.sh` to expose them to Claude Code, Codex and Gemini (symlinks), or `bash scripts/link-skills.sh --copy` if a tool does not follow symlinks.
- Edit skills only in `skills/`. Never edit the linked or copied folders.
- Tools without file access: paste `AGENTS.md` into the instructions and upload only the skill, master and job description needed. Never upload private notes to tools you do not control.
- Order of use: tailor-resume, ats-keyword-check, verify-claims, cover-letter, interview-prep.

## Repository Tree Structure

This is the full tree with everything we've created. The comments mark what's generated or optional.

```
master-resume/
├── README.md                      # workflow and setup
├── AGENTS.md                      # canonical agent rules (edit this)
├── CLAUDE.md                      # one line: @AGENTS.md
├── tracker.csv                    # application log
├── .env                           # for scripts + personal info / links / contact headers (never committed)
├── .env.example
├── .gitignore
│
├── master/
│   └── master-resume.md           # source of truth (metrics log and private notes are sections 6-7)

├── industry/                      # industry-specific resume tailoring guides + templates
│   ├── design/
│   └── dev/
│
├── skills/                        # canonical skills (edit these)
│   ├── resume-tailor-quick/SKILL.md
│   ├── resume-ats-optimizer/SKILL.md
│   ├── verify-claims/SKILL.md
│   ├── cover-letter-generator/SKILL.md
│   └── interview-prep-generator/SKILL.md
│
├── templates/
│   ├── dev.md
│   ├── hybrid.md
│   ├── design.md
│   └── style.css                  # PDF stylesheet
│
├── scripts/
│   ├── build.sh                   # tag filter and PDF export
│   ├── new-application.sh         # creates an application folder
│   └── link-skills.sh             # links or copies skills for each tool
│
├── applications/                  # one folder per job
│   └── 2026-10-acme-frontend/     # example, created by new-application.sh
│       ├── job-description.md
│       ├── resume.md
│       ├── resume.pdf             # exact file submitted
│       ├── cover-letter.md
│       └── notes.md
│
├── archive/                       # retired bullets, old submissions
│
├── .claude/skills -> ../skills    # generated by link-skills.sh
└── .codex/skills  -> ../skills    # generated, only if you use Codex
```
