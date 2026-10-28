# MVP: Application Pipeline V1

**Status:** Draft | **Parent:** [PRODUCT-SPEC.md](PRODUCT-SPEC.md), [AGENTS.md](../AGENTS.md)

> **Note:** This MVP deliberately does not cover all of [PRODUCT-SPEC.md](PRODUCT-SPEC.md). The spec is the aspirational target; this doc is the smallest first version that is useful. Where they differ, the MVP wins for V1, and the spec is where cut features live until a trigger below brings them back.

## Goal

Turn a job description into a verified, one-to-two page resume (and optionally a cover letter) in one sitting, using the scripts and skills that already exist. No new CLI, no model API, no database.

## Workflow

1. **Intake.** Run `bash scripts/new-application.sh company-role`. Paste the job description into `applications/<YYYY-MM-company-role>/job-description.md`.
2. **Tailor.** In the agent session, run `resume-tailor-quick`, then `resume-ats-optimizer`. The agent writes `resume.md` in the application folder and never edits `master/`. Run `cover-letter-generator` only if the job needs a letter.
3. **Verify.** Run `verify-claims`. It writes `verify-report.md` listing supported claims, unsupported claims, `TODO` items and citations to master lines. Carrie checks that each citation supports its claim. Any unsupported or uncited claim blocks the next step.
4. **Approve.** After a clean verify, Carrie sets the application's row in `tracker.csv` to `ready`. Editing a draft after approval means running step 3 again.
5. **Export.** Carrie runs `bash scripts/build.sh applications/<folder>/resume.md` locally so `.env` fills the contact header. The only new code is a page-count check that fails above two pages.

## Build checklist

Everything the workflow needs already exists except the items below. Do them in order.

- [ ] **1. Confirm the existing pieces run end to end.** Run steps 1-4 of the workflow on one real or synthetic job description. Note anything that breaks; fix only what blocks the MVP.
- [ ] **2. Check `verify-claims` output.** Confirm it writes `verify-report.md` with supported claims, unsupported claims, `TODO` items and master-line citations. If it doesn't, adjust the skill, not the workflow.
- [ ] **3. Add the page-count check.** After the PDF build in `scripts/build.sh`, count the pages and exit non-zero with a clear message above two pages. Use a tool already installed with weasyprint or pandoc; add no new dependency.
- [ ] **4. Test the page-count check.** Extend `tests/test-pdf-export.sh` with synthetic fixtures: one that builds at one or two pages and passes, and one over two pages that fails. The CI step for it already exists in `.github/workflows/tests.yml`.
- [ ] **5. Add `ready` status helper (optional).** A one-line script or a documented manual edit that sets the row's `status` to `ready` in `tracker.csv`. Skip it if editing by hand is fine.
- [ ] **6. Run the pilot.** Do three real applications through the full workflow, noting intake and approval times. Fix only problems that block or mislead.
- [ ] **7. Update the docs.** Point `README.md` at this workflow, and add a line to `docs/CHANGELOG.md`.

## Hard gates

- Zero unsupported claims in anything marked `ready`.
- Metrics come only from master section 6, using its safe wording for Estimate, Projection and Self-reported rows.
- Content from master sections 6-10 never appears in output.
- One page is the target; two pages is the limit.
- A human approves; the agent never sets `ready`.

## New work

| Item | Size |
|---|---|
| Page-count check after the PDF build (fail above 2 pages) | Small addition to `build.sh` or a wrapper |
| One test for the page-count check using a synthetic fixture, run in `.github/workflows/tests.yml` | Small |
| Optional: a one-line script to set a `tracker.csv` row to `ready` | Trivial |

Everything else reuses `new-application.sh`, `build.sh`, the skills and `tracker.csv`.

## Out of scope for V1

- Python CLI or orchestrator, and any external model API (provider config, cost threshold, outbound payload preview, retention review, public-safe fact allowlist).
- Tag-confirmation and regeneration loop; pick tags in the chat.
- Approval hash manifest and `needs-review` status; use git to see edits after approval.
- Revision management; use git history.
- Batch processing, assisted submit, web app, job feed, interview prep, outcome analytics.

## Add later only if triggered

| Trigger | Add |
|---|---|
| A draft is edited after approval and the change goes unnoticed | Hash check against an approval manifest |
| Running the pipeline in the agent session is too slow or costly | The API CLI from `PRODUCT-SPEC.md` |
| Ten consecutive applications with zero unsupported claims, clean builds and recorded approval | Batch processing |

## Pilot measure

For the first three applications, note the intake and approval times in `tracker.csv` or `notes.md`. Use their median to set a time-saving target; the self-reported manual baseline is 30-60 minutes.

## Done when

- [ ] A JD goes in and a verified `resume.md` comes out without manual rewriting from scratch.
- [ ] `verify-report.md` shows no unsupported claims before `ready` is set.
- [ ] The PDF builds and the page-count check passes at one or two pages, and fails above two.
- [ ] No tag names or section 6-10 content appear in the output.
