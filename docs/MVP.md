# MVP: Application Pipeline V1

**Status:** Draft | **Parent:** [PRODUCT-SPEC.md](PRODUCT-SPEC.md), [AGENTS.md](../AGENTS.md)

> The spec is the aspirational target; this is the smallest useful first version. Where they differ, the MVP wins for V1. Cut features live in the spec until a trigger below brings them back.

## Goal

Turn a job description into a verified, one-to-two page resume (and optionally a cover letter) in one sitting, using existing scripts and skills. No new CLI, model API or database.

## Workflow

#todo - create a workflow skill that runs all steps in a row and stops only if a step fails.

1. ~~**Intake.**~~ `bash scripts/new-application.sh company-role`, then paste the job description into `applications/<YYYY-MM-company-role>/job-description.md`.
2. ~~**Tailor.**~~ Run `resume-tailor-quick`. The agent writes `resume.md` and never edits `master/`. Run `cover-letter-generator` only if a letter is needed.
3. ~~**Verify.**~~ Run `verify-claims`; it writes `verify-report.md` (supported claims, unsupported claims, `TODO` items, master-line citations). Carrie checks each citation. Any unsupported or uncited claim blocks the next step.
4. **Approve.** After a clean verify, Carrie runs `bash scripts/ready.sh <folder>`. The agent never runs it. Status flow: `pending` -> `tailored` -> `verified` -> `ready` -> `exported` (`build.sh` sets the last). Editing a draft after approval means verifying again.
5. **Export.** Carrie runs `bash scripts/build.sh applications/<folder>/resume.md` locally so `.env` fills the header. It writes `<folder>-resume.docx` to `~/Downloads`. A `.docx` has no fixed page count, so Carrie checks in Word that it is one page (two at most).

## Build checklist

- [ ] **1. End-to-end run.** Run workflow steps 1-5 on one real or synthetic job description. Fix only what blocks the MVP.
- [ ] **2. Check `verify-claims` output.** Confirm `verify-report.md` has the sections above. If not, fix the skill, not the workflow.
- [x] **3. `ready` helper.** Done: `scripts/ready.sh`.
- [ ] **4. Pilot.** Three real applications through the full workflow, noting intake and approval times.
- [ ] **5. Update docs.** Point `README.md` at this workflow; add a `CHANGELOG.md` line.

## Hard gates

- Zero unsupported claims in anything marked `ready`.
- Metrics only from master section 6, using its safe wording for Estimate, Projection and Self-reported rows.
- Master sections 6-10 never appear in output.
- One page target; two pages limit.
- A human approves; the agent never sets `ready`.

## Out of scope for V1

- Python CLI or orchestrator, external model API (provider config, cost threshold, payload preview, retention review, public-safe fact allowlist).
- Tag-confirmation and regeneration loop; pick tags in chat.
- Approval hash manifest and `needs-review` status; use git.
- Revision management; use git history.
- Batch processing, assisted submit, web app, job feed, interview prep, outcome analytics.

## Add later only if triggered

| Trigger | Add |
| --- | --- |
| A draft is edited after approval and the change goes unnoticed | Hash check against an approval manifest |
| Running the pipeline in the agent session is too slow or costly | The API CLI from `PRODUCT-SPEC.md` |
| Ten consecutive applications with zero unsupported claims, clean builds and recorded approval | Batch processing |

## Pilot measure

Note intake and approval times for the first three applications in `tracker.csv` or `notes.md`. Their median sets the time-saving target; the self-reported manual baseline is 30-60 minutes.

## Done when

- [ ] A JD goes in and a verified `resume.md` comes out without rewriting from scratch.
- [ ] `verify-report.md` shows no unsupported claims before `ready` is set.
- [ ] The `.docx` builds and is one or two pages in Word.
- [ ] No tag names or section 6-10 content appear in the output.
