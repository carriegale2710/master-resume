# Resume repo

Private repo for my master resume and every tailored application.

## Tree

```text
master-resume/
├── README.md                  # how the workflow works
├── master/
│   ├── master-resume.md       # source of truth (edit only here)
│   ├── metrics-log.md         # evidence for every number
│   └── private-notes.md       # NDA notes, interview stories (never exported)
├── templates/
│   ├── dev.md                 # section order and layout per role family
│   ├── design.md              # design resume structure
│   ├── hybrid.md              # hybrid resume structure
│   └── style.css              # shared PDF stylesheet
├── role/                      # role-specific resume tailoring guides + templates
│   ├── design/
│   └── dev/
├── applications/
│   └── 2026-10-acme-frontend/
│       ├── job-description.md # pasted posting (may vanish)
│       ├── resume.md          # tailored copy of the master
│       ├── cover-letter.md    # optional application cover letter
│       ├── resume.pdf         # exact PDF submitted
│       └── notes.md           # contacts, interview prep, outcome
├── archive/                   # retired bullets and old submissions
├── tracker.csv                # date, company, role, version, status, outcome
├── scripts/
│   ├── build.sh               # markdown -> PDF (pandoc + weasyprint)
│   └── new-application.sh     # creates a new app folder and stub files
├── .gitignore
└── .env                        # for scripts + personal info / links / contact headers (never committed)

```

## Rules

1. Edit **only** `master/master-resume.md`. Never treat a tailored copy as the source.
2. One folder per application in `applications/`, named `YYYY-MM-company-role`.
3. If I improve a bullet while tailoring, copy it back to the master the same day.
4. Every number needs a row in the metrics log (section 6 of the master).
5. Keep this repo **private**. It contains contact details and NDA notes.

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

## Setup

After cloning, run `chmod +x scripts/*.sh` once.

## Requirements

- `pandoc` (required)
- `weasyprint` (PDF engine): `pip install weasyprint`

## Maintenance

- Within 1 week of finishing anything: update the master and metrics log.
- Monthly: check links and demo URLs.
- Quarterly: move stale bullets to `archive/`.
