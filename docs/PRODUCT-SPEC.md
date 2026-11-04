# PRD: Application Pipeline (Lean MVP)

**Status:** ~~Draft~~ V1 shipped; V2 not built | **Author:** Carrie | **Parent:** [README.md](../README.md), [AGENTS.md](../AGENTS.md)

> **How to read this spec (revised 2026-11-03).** ✅ = shipped as written. ~~Struck text~~ = dropped or replaced. **Changed:** = shipped differently; the note describes what exists. Unbuilt API-CLI material lives in [V2 (not built)](#v2-not-built). Code changes agreed but not yet made are in [Planned V1 changes](#planned-v1-changes).

## Overview

Manual tailoring takes a self-reported 30-60 minutes per application (sometimes a full day). This turns it into a local ~~CLI~~ workflow: provide a job description, generate editable resume and cover-letter drafts, verify claims, approve the Markdown, export a .docx. Drafts stay unapproved until the user reviews and marks them ready. Export and submission are separate manual steps. ~~Batch processing waits for the single-application reliability pilot.~~

**Changed:** the workflow is `scripts/tailor.sh` (interactive Bash) opening one Claude Code session per skill, then `scripts/build.sh` for approval and export. Batch processing is dropped.

## Problem Statement

Carrie is a recent graduate applying to graduate programs, internships, part-time work, software development and UX design roles. Each needs different tailoring. Perfectionism can turn one application into a full day and cause missed deadlines; for less compelling roles, the effort can lead to a generic resume. She has a strong master resume but 20+ draft versions in one folder and cannot tell which is latest. She dislikes writing and wants to delegate, but will not accept generic text or unsupported claims.

The 30-60 minute and full-day durations and the 20+ draft count are self-reported, as are the missed deadlines and generic submissions.

## Goals & Success Metrics

| Metric                                                             | Baseline                                                 | Target                                           | Timeframe |
| ------------------------------------------------------------------ | -------------------------------------------------------- | ------------------------------------------------ | --------- |
| ~~Median elapsed time from application intake to approved drafts~~ | ~~Manual workflow: self-reported estimate of 30-60 minutes~~ | ~~Set after the first three pilot applications~~ | ~~Pilot~~ |
| Unsupported claims in final approved output                        | n/a                                                      | 0                                                | Always    |
| ✅ Successful docx build                                           | n/a                                                      | 100%                                             | Always    |
| ✅ Explicit human approval recorded before `ready`                 | n/a                                                      | 100%                                             | Always    |

~~Record intake and approval timestamps for each pilot application; use the first three to set a time-reduction target for subsequent applications.~~

**Changed:** the time metric is dropped. Elapsed time depends on the model, and no pilot timings were recorded. Success is measured by output quality instead.

### Quality metrics

One row per application in `applications/quality-log.csv`, keyed by the tracker `id`. Counts are written automatically; ratings (1-5) are the user's own. No model-scored metrics: they shift when the model changes. Not built yet; see [Planned V1 changes](#planned-v1-changes).

| Column             | Measures                                                   | Written by           | When                         |
| ------------------ | ---------------------------------------------------------- | -------------------- | ---------------------------- |
| `verify_fails`     | Resume `verify-claims` FAIL runs before PASS (revisions)   | `tailor.sh`          | Verify loop                  |
| `cl_verify_fails`  | Same, for the cover letter                                 | `tailor.sh`          | Verify loop                  |
| `verify_skipped`   | `y` if the verify gate was overridden                      | `tailor.sh`          | Verify loop                  |
| `claims_caught`    | Unsupported claims flagged                                 | `verify-claims`      | Each FAIL                    |
| `keyword_coverage` | Share of job-ad keywords the master supports that the resume uses | `resume-orchestrator` | After `application-lint` |
| `ats_lint`         | PASS/FAIL on ATS-safe structure                            | `resume-orchestrator` | After `application-lint`    |
| `resume_rating`    | User rating: quality and readability                       | User via `build.sh`  | Resume y/N approval          |
| `cl_rating`        | User rating: letter quality and human-sounding prose       | User via `build.sh`  | Cover-letter y/N approval    |
| `outcome_rating`   | User rating: how well it landed (employability)            | User                 | When tracker `outcome` is known |

### Guardrail metrics

- ~~No private master content (section 6, `master/metrics-log.csv`, `master/narrative-notes.md`, `master/archive.md`) is sent to the model or copied into application output.~~
  **Changed:** Claude Code may read every repo file except `.env`. No private master content (section 6, `master/metrics-log.csv` beyond evidenced numbers in their safe wording, `master/narrative-notes.md`, `master/archive.md`) may appear in application output.
- ~~Every factual claim in final output is mapped to an exact supporting master line; metric claims are checked locally against `master/metrics-log.csv` and use its safe wording where applicable, and other numbers are checked against their cited lines.~~
  **Changed:** `verify-claims` checks numbers against `master/metrics-log.csv` (with its safe wording) and facts against the master. Per-claim citations are a [V2 feature](#v2-not-built).
- ✅ Unapproved drafts may contain claims flagged by verification; none may remain unsupported in the final approved output.

## Persona

**Carrie, recent graduate and solo job seeker.** Comfortable with a terminal and git, dislikes writing, perfectionistic about quality. Has built custom agent skills and templates for tailoring and wants AI to follow them without sounding generic. Wants editable drafts to review, delegates as much as possible, and will not approve a claim she cannot defend in an interview.

## Scope

V1 shipped as the existing scripts and skills (`tailor.sh`, `verify-claims`, `build.sh`); no CLI, model API or database. Where this spec differs, V1 as shipped wins. Add the following only if triggered:

| Trigger                                                                                           | Add                                                                  |
| ------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------- |
| A draft is edited after approval and the change goes unnoticed                                    | Hash check against an approval manifest                              |
| A `verified` or exported draft is found to contain an unsupported number or claim                 | Inline citations checked by `verify-claims` ([V2](#v2-not-built))    |
| Running the pipeline in the agent session is too slow or costly                                   | The API CLI ([V2](#v2-not-built))                                    |
| ~~Ten consecutive applications with zero unsupported claims, clean builds and recorded approval~~ | ~~Batch processing~~ (dropped)                                       |

### In Scope (V1)

~~A local CLI wrapper around the existing scripts and a configurable OpenAI-compatible API for an open-weight model. The API is used for tag suggestions and draft generation, not as the final verifier. No web app or database in V1. The specific model and endpoint may be selected later.~~

**Changed:** `tailor.sh` wraps the existing scripts and opens Claude Code sessions for the skills (`tracker-intake`, `resume-orchestrator`, `verify-claims`, `job-application-agent:cover-letter`). No model API, web app or database. The API version moved to [V2](#v2-not-built).

### Non-Goals (V1)

- Automated form submission or browser automation on job boards.
- Web app, accounts, multi-user, hosting.
- Job scraping or discovery/search feeds.
- ~~Batch processing; reconsider only after the single-application reliability pilot passes.~~ Batch processing.
- Interview prep generation (existing skill, run manually).
- Auto-learning from outcomes.
- ~~Recruiter response-rate analytics as a V1 success measure.~~ (Removed: `outcome_rating` now tracks this.)

## Functional Requirements

- **FR1: Intake.** ~~`apply <company-role> [--jd FILE]` calls `scripts/new-application.sh` (which also creates `notes.md` and an empty `cover-letter.md`) and saves the job description to `applications/<YYYY-MM-company-role>/job-description.md`. If `--jd` is omitted, prompt for pasted text. V1 also accepts a local JD file; URL fetching is deferred.~~
  **Changed:** `tailor.sh` step 1 asks for the company, role, URL, pasted job description (ended by `END`) and closing date. It calls `scripts/new-application.sh` and writes `job-description.md`. Step 2 runs `tracker-intake` to fill the tracker row. No `--jd FILE` and no URL fetching.
- **FR2: Role-family selection.** ~~In one generation request, the model receives the job description and user-approved public-safe fact allowlist, recommends tags from the README tag list, and returns initial resume and cover-letter drafts. The CLI shows the proposed tags; the user can change them and regenerate with the confirmed tags. The confirmed tags are recorded with the application.~~
  **Changed:** `resume-orchestrator` picks tags in the session; the user can redirect it in chat. Tags are not recorded. The API tag loop moved to [V2](#v2-not-built).
- ✅ **FR3: Tailor.** ~~The model tailors the resume per `AGENTS.md` and `.claude/skills/resume-drafter`: 5-7 bullets per role family, keywords mirrored only where the master supports them, Australian English, and no tag names in output. It writes an unapproved `resume.md` in the application folder and never touches `master/`.~~ Shipped as `resume-orchestrator` (job-ad decoding, `resume-drafter`, `application-lint`), which sets status `tailored`.
- ✅ **FR4: Cover letter.** ~~The model returns an unapproved `cover-letter.md` per the `job-application-agent:cover-letter` plugin skill, using only the approved public-safe facts and job description.~~
  **Changed:** `tailor.sh` step 5 (optional) runs `job-application-agent:cover-letter`; `humanize-prose` then `verify-claims` run on the letter. The skill reads the master, not an allowlist.
- **FR5: Verify (approval gate).** ~~Each factual claim in the resume and cover letter must cite an exact supporting line from master sections 1-5. The verifier reports its result in the session (not a saved file), listing supported claims, unsupported claims, TODO items, and citations. Local code validates that cited lines exist and checks metric claims against `master/metrics-log.csv`, applying its safe wording where required; the metrics log is used locally only, and its contents are never sent to the API. Other numbers must be supported by their cited master line. The user confirms that each citation semantically supports its claim. Ambiguous or uncited claims count as unsupported and block `ready`. A user may resolve a verifier false positive only by supplying an exact supporting master-line citation; genuinely unsupported claims cannot be overridden.~~
  **Changed:** `verify-claims` reports PASS/FAIL in the session with a numbered issue list (numbers, unsafe claims, TODOs, private content, consistency, leftovers, length). On PASS it sets `verified`. `tailor.sh` loops it until PASS. The user may override with `skip`; ~~the override is not recorded~~ every override is recorded as `verify_skipped` in `quality-log.csv` (planned). Local deterministic checks and per-claim citations are deferred behind a [trigger](#scope).
- **FR6: Review and approval.** ~~The CLI displays what was cut, what was reworded, gaps, and every claim still needing evidence. After any edits, verification must run against the exact current Markdown. The user explicitly approves in the CLI; only then is the application's row in `tracker.csv` set to `ready`. Whenever a CLI command relies on `ready` or exports approved content, it compares the current Markdown hashes with the approval manifest. A mismatch changes the tracker status to `needs-review` and blocks the operation until verification and approval are repeated.~~
  ✅ Skills report what was cut, what was reworded and every claim still needing evidence (`AGENTS.md` "Always report"). ✅ `build.sh` asks y/N; yes sets `ready`, then `exported`.
  **Changed:** no hash manifest or `needs-review` (behind a [trigger](#scope)). Status resets to `tailored` only when a skill redrafts. Planned: `tailor.sh` stops resetting status before every verify run, and step 6 adds a skippable "Edited since verify? re-verify" reminder that resets status before re-running `verify-claims`.
- ✅ **FR7: docx export.** A separate ~~CLI~~ command exports approved Markdown via `scripts/build.sh applications/<folder>/resume.md` (`build.sh` builds the `.docx` and fills `${RESUME_*}` contact placeholders from `.env`). One page is the target; up to two pages are allowed when needed to preserve relevant, supported evidence. Page count is checked manually in Word, because a `.docx` has no fixed page count. Docx export is not required to mark the Markdown `ready`, and submission remains manual.
  **Changed:** `build.sh` sets `ready` at the same y/N prompt that builds, writes to `~/Downloads`, asks before re-exporting an `exported` row, and offers `cover-letter.md` (gated on `cover_letter_status`).
- **FR8: Regeneration and failures.** ~~Regeneration creates a separate revision and preserves all existing drafts, including user-edited drafts; the user chooses which version to keep.~~ ✅ On model, verification, or export failure, stop that operation with a clear error, preserve the JD and existing drafts, and never mark unsupported or unapproved content ready.
  **Changed:** git history replaces revisions. `tailor.sh` reports a non-zero skill exit and continues to the next prompt.

## Main User Flows

The diagrams below show the ~~V1~~ original happy paths and the main negative paths or recovery loops. A failed operation preserves the JD and existing drafts; it does not create an approved result.

**Changed:** Flow 1 is the V2 API flow (kept in [V2](#v2-not-built)). V1 intake is `tailor.sh` steps 1-3. In Flows 2-3, the hash steps are deferred and verification is `verify-claims`, not local code. In Flow 4, git replaces revisions. Diagrams are kept as the original design.

**Diagram legend:** blue = AI agent, grey = local CLI/system, yellow = manual user action or review, green = successful outcome, red = stop or failure.

### Flow 2: Verification, review, and approval

```mermaid
flowchart TD
    A([Unapproved drafts]) --> B[Run local verification]
    B --> C[Check citations, TODOs, and numbers locally]
    C --> D{Any unsupported, ambiguous, or invalid claims?}
    D -->|Yes| E[Show claims, gaps, cuts, and rewording]
    E --> F[User edits drafts or adds exact citations]
    F --> B
    D -->|No| G[User confirms citations semantically]
    G -->|Citation not supported| E
    G -->|All citations supported| H[User explicitly approves]
    H --> I[Record approval against file hashes]
    I --> J[Set application tracker status to ready]
    J --> K([Approved Markdown])
    F -->|Content changed after approval| B
    classDef ai fill:#dbeafe,stroke:#2563eb,color:#1e3a8a
    classDef system fill:#e5e7eb,stroke:#6b7280,color:#1f2937
    classDef user fill:#fef3c7,stroke:#d97706,color:#78350f
    classDef success fill:#dcfce7,stroke:#16a34a,color:#14532d
    classDef error fill:#fee2e2,stroke:#dc2626,color:#7f1d1d
    class A,E,F,G,H user
    class B,C,D,I,J system
    class K success
```

### Flow 3: Approved Markdown to docx

```mermaid
flowchart TD
    A([Approved Markdown]) --> B[Check ready status and file hashes]
    B -->|Hash mismatch| C[Set tracker status to needs-review]
    C --> D([Refuse export; reverify and reapprove])
    B -->|Not ready| D
    B -->|Hashes valid| E[Run docx build]
    E -->|Build failure| F([Report error; preserve drafts and approval])
    E --> G{Docx is one or two pages in Word?}
    G -->|Yes| H([Docx exported])
    G -->|More than two pages| I([Fail clearly; no approved export])
    classDef ai fill:#dbeafe,stroke:#2563eb,color:#1e3a8a
    classDef system fill:#e5e7eb,stroke:#6b7280,color:#1f2937
    classDef user fill:#fef3c7,stroke:#d97706,color:#78350f
    classDef success fill:#dcfce7,stroke:#16a34a,color:#14532d
    classDef error fill:#fee2e2,stroke:#dc2626,color:#7f1d1d
    class A user
    class B,C,E,G system
    class D,F,I error
    class H success
```

### Flow 4: Regeneration and failure recovery

```mermaid
flowchart TD
    A([Existing JD or draft]) --> B[Request regeneration or rerun operation]
    B --> C[Create separate revision]
    C -->|Model, verifier, or export failure| D[Show clear error]
    D --> E([Preserve JD and all existing drafts])
    C --> F[User compares revisions]
    F --> G{Choose version to keep}
    G -->|Earlier or edited draft| H[Keep selected existing revision]
    G -->|New revision| I[Keep new revision]
    H --> J([Continue from selected unapproved draft])
    I --> J
    classDef ai fill:#dbeafe,stroke:#2563eb,color:#1e3a8a
    classDef system fill:#e5e7eb,stroke:#6b7280,color:#1f2937
    classDef user fill:#fef3c7,stroke:#d97706,color:#78350f
    classDef success fill:#dcfce7,stroke:#16a34a,color:#14532d
    classDef error fill:#fee2e2,stroke:#dc2626,color:#7f1d1d
    class A,B,F,G,H,I user
    class D system
    class C ai
    class E error
    class J success
```

## Non-Functional Requirements

- **Privacy:** ~~The model receives only the job description and a reusable, user-approved public-safe fact allowlist curated from master sections 1-5. It never receives the full master resume or private master content. `master/metrics-log.csv` stays local for metric checks and application of any required safe wording.~~ ✅ Use generic wording for Outlier / Scale AI work unless the user confirms otherwise. ~~Before each API call, show the complete outbound request payload, including the JD and approved facts. Before the first live call, review the selected provider's request handling and data-retention terms.~~ ✅ Keep credentials out of application artifacts and Git.
  **Changed:** Claude Code may read every repo file except `.env` (`.claude/settings.json` denies reads of it). Private content must never appear in output. The allowlist and payload preview moved to [V2](#v2-not-built).
- ~~**Provider interface:**~~ Moved to [V2](#v2-not-built).
- ~~**Cost:**~~ Moved to [V2](#v2-not-built).
- ~~**Latency:** Under 3 minutes per application, excluding human review, is a non-blocking operational target.~~ Dropped with the time metric.
- **Idempotent:** ~~Never overwrite an existing draft on regeneration; create a separate revision.~~ **Changed:** `new-application.sh` refuses to overwrite a folder; draft history is git.
- **Auditable:** ✅ Application artifacts live in git per application folder~~, with model name and date in `notes.md`. Approval is recorded against hashes of the exact verified Markdown files. Whenever the CLI relies on approval, it checks those hashes; a mismatch sets the application's tracker status to `needs-review`~~.
  **Changed:** audit trail is git, `tracker.csv` (`last_update` per status change) and `quality-log.csv` (planned). Hash checks are behind a [trigger](#scope).

## Architecture (lean)

~~Local CLI modular monolith: a small Python orchestrator, no services.~~

**Changed:** Bash + Claude Code, no services, no Python.

```
tailor.sh (intake: new-application.sh + pasted JD)
    -> Claude Code sessions: tracker-intake, resume-orchestrator, verify-claims (loop), optional cover-letter
    -> build.sh: status gate + y/N approval -> tracker.csv (`ready`) -> .docx -> (`exported`)
    -> page count checked manually in Word
```

Choices and reasons:

- ✅ **Reuse first:** `new-application.sh`, `build.sh`, `.claude/skills/*` and `tracker.csv` already exist. ~~Keep the shell scripts as the folder-setup and docx-export layer; the CLI orchestrates them rather than reimplementing them.~~ `tailor.sh` orchestrates them; general skills come from the `job-application-agent` plugin.
- ~~**Language:** Python 3 for the orchestrator and verification workflow.~~ **Changed:** Bash (Git Bash on Windows) with gawk and Pandoc. Python moved to [V2](#v2-not-built).
- ~~**Provider compatibility:**~~ Moved to [V2](#v2-not-built).
- ~~**Local verification:** validate citations against master lines, check metric claims against `master/metrics-log.csv`, and check other numbers against their cited lines. The model may propose source references, but only the local checks and user's semantic review can satisfy the approval gate.~~ **Changed:** `verify-claims` plus the user's y/N approval form the gate.
- **State:** ✅ application files and `tracker.csv`. ~~a small per-application approval manifest~~ (behind a [trigger](#scope)). Planned: `quality-log.csv`. ✅ No database until there is a demonstrated need.
- ✅ **Reversibility:** drafts remain plain Markdown and approval metadata stays local.

## Edge Cases

| Case                                                | Expected behaviour                                                                                                                                              | Status |
| --------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| JD asks for a skill not in master                   | Omit; list under "gaps" in the review summary. Never add it.                                                                                                    | ✅ |
| User changes tags after model suggestion            | ~~Regenerate using the confirmed tags; preserve earlier draft revisions.~~                                                                                      | **Changed:** redirect the orchestrator in chat; git keeps history |
| Resume exceeds one page                             | Target one page; preserve relevant supported evidence up to two pages; fail clearly above two pages.                                                            | **Changed:** `verify-claims` estimates pages and FAILs above two; `build.sh` does not check |
| Master field marked `TODO`                          | Flag in the verify output; leave out of the output.                                                                                                             | ✅ (`build.sh` also warns) |
| Metric marked Estimate / Projection / Self-reported | Use safe wording from `master/metrics-log.csv`.                                                                                                                 | ✅ |
| Duplicate company-role in same month                | `new-application.sh` exits with "Already exists"; ~~the CLI stops, creates nothing~~ and preserves the existing folder. Use a different name.                   | ✅ (`tailor.sh` re-prompts) |
| User edits output after verification or approval    | ~~At the next CLI check that relies on approval, compare file hashes; on mismatch, set tracker status to `needs-review` and require re-verification and approval.~~ | **Changed:** planned step-6 re-verify reminder; hash check behind a [trigger](#scope) |
| ~~Cost estimate exceeds USD 0.50~~                  | Moved to [V2](#v2-not-built).                                                                                                                                   | V2 |
| Model, verifier, or docx export fails               | Report the error, preserve the JD and drafts, and do not mark ready.                                                                                            | **Changed:** model and verifier failures hold. A docx build failure after y leaves `ready`; see [Planned V1 changes](#planned-v1-changes) |

## Acceptance Criteria

- [x] ~~Given a local JD file, when I run `apply acme-frontend --jd jd.md`, then~~ **Changed:** given a pasted JD in `tailor.sh`, the application folder contains the JD and unapproved Markdown drafts; no docx is exported before approval.
- [ ] Given a metric claim absent from `master/metrics-log.csv`, when ~~local~~ verification runs, then `ready` is blocked and the claim is named; ~~given another number, verification checks that its cited master line supports it.~~ **Changed:** done by `verify-claims` (model), not local code; no automated test.
- [ ] ~~Given a factual claim without an exact supporting master-line citation, then it is listed as unsupported and blocks approval.~~ Deferred: [V2](#v2-not-built) citations.
- [ ] ~~Given a citation to a master line, then local code confirms that the line exists and the user confirms that it semantically supports the claim.~~ Deferred: [V2](#v2-not-built) citations.
- [x] Given a JD requiring a skill absent from master, then it is absent from the resume and listed as a gap.
- [x] Given any generated output, then it contains no tag names and no private master content.
- [x] Given an approved draft, then the user can export a .docx separately; the user confirms it is one or two pages in Word.
- [ ] ~~Given any approval-dependent operation on Markdown whose contents no longer match the approval manifest, then the CLI sets tracker status to `needs-review` and refuses to treat it as `ready` or export it as approved until it is reverified and reapproved.~~ Deferred behind a [trigger](#scope).
- [x] ~~Given regeneration, then a new revision is created without overwriting prior or user-edited drafts.~~ **Changed:** git history.
- [x] Given explicit approval of the verified Markdown, then the application's row in `tracker.csv` has status `ready`.
- [x] `tests/` ~~gains tests using synthetic fixtures only (number check, outbound payload excludes private master content, approval-hash mismatch), run by a new step in `.github/workflows/tests.yml`~~ uses synthetic fixtures only, run by `tests/run-all.sh` in `.github/workflows/tests.yml`. Removal of section 6 from `build.sh` output is ~~already~~ covered by `tests/test-build.sh`. **Changed:** the number-check, payload and hash tests target unbuilt features.

## Rollout Plan

1. ✅ **Pilot:** single-application flow, ~~local checks, CLI approval state~~ `verify-claims`, `build.sh` approval, separate docx export. ~~Track failures on real applications.~~ **Changed:** three real applications ran; no timings or failure counts were recorded. `quality-log.csv` replaces this.
2. ~~**Reliability gate:** after 10 consecutive applications with zero unsupported claims in approved output, successful builds and recorded approval, add batch.~~ Dropped.
3. ~~**Batch:** `apply-batch jobs.txt`, sequential, continues after item failures, builds a review queue, never auto-approves.~~ Dropped.

## Planned V1 changes

Agreed 2026-11-03; not built yet. Each needs a synthetic-fixture test.

- [ ] `applications/quality-log.csv` (columns in [Quality metrics](#quality-metrics)) and `scripts/log-quality.sh <folder> <column> <value>`, reusing the quote-aware awk from `set-status.sh` and creating the row if missing.
- [ ] `tailor.sh`: count FAIL runs into `verify_fails` / `cl_verify_fails`; write `verify_skipped` on `skip`; stop resetting status to `tailored` before every verify run.
- [ ] `tailor.sh` step 6: skippable "Edited since verify? [Enter] export | v re-verify" reminder. `v` resets status (`tailored`, or `cover drafted` for the letter) before running `verify-claims`, so a FAIL cannot leave a stale `verified`.
- [ ] `build.sh`: after each y/N approval, ask "Rate 1-5 (Enter to skip)" and write `resume_rating` / `cl_rating`.
- [ ] `verify-claims`: on FAIL, write `claims_caught`.
- [ ] `resume-orchestrator`: after `application-lint`, write `keyword_coverage` and `ats_lint`.

Found 2026-11-04 in the README check; fixes not yet agreed. Details in [ISSUES.md](../ISSUES.md).

- [ ] `build.sh`: a failure after y (missing `.env`, missing variable, no Pandoc) leaves the row `ready`, and line 54 then refuses every rebuild. Proposed fix: accept `ready` at line 54. Recovery until then: `bash scripts/set-status.sh <folder> verified`.
- [ ] `build.sh`: every resume build tries the empty `cover-letter.md` from `new-application.sh` and prints an error when `cover_letter_status` is `none`. Proposed fix: gate line 99 on status.

## V2 (not built)

Not committed. Kept from the original spec.

### API CLI

A local Python CLI wrapper around the existing scripts and a configurable OpenAI-compatible API for an open-weight model. Trigger: running the pipeline in the agent session is too slow or costly.

- **Intake:** `apply <company-role> [--jd FILE]`; prompt for pasted text if `--jd` is omitted. URL fetching deferred.
- **Role-family selection:** in one generation request, the model receives the job description and a user-approved public-safe fact allowlist, recommends tags from the README tag list, and returns initial resume and cover-letter drafts. The CLI shows the proposed tags; the user can change them and regenerate. The confirmed tags are recorded with the application.
- **Privacy:** the model receives only the JD and a reusable, user-approved public-safe fact allowlist curated from master sections 1-5, never the full master or private content. `master/metrics-log.csv` stays local. Before each API call, show the complete outbound payload. Before the first live call, review the provider's request handling and data-retention terms.
- **Provider interface:** configurable endpoint and model. Credentials from the ignored `.env` with environment variables taking precedence, using variable names separate from `RESUME_*`; agents never read or write `.env`. Record the provider and model used; never log prompts or secrets. Do not assume every OpenAI-compatible provider supports identical parameters; validate responses and fail clearly.
- **Cost:** track estimated and actual cost per application. If an estimate exceeds USD 0.50, ask before the call (consent threshold, not a hard stop).
- **Language:** Python 3, standard library first, a few focused modules (intake/orchestration, provider, verification, approval). Existing Bash scripts stay the setup and build layer.
- **Acceptance:** the complete outbound payload is shown before the API call and never contains private master content; an estimate above USD 0.50 waits for confirmation.

#### Flow 1: Intake and draft generation

```mermaid
flowchart TD
    A([Start]) --> B[Run apply with JD file]
    B -->|No file| C[Paste JD text]
    B -->|File provided| D[Save JD in application folder]
    C --> D
    D --> E[Show full outbound request and estimated cost]
    E -->|Cost over USD 0.50| F{User confirms API call?}
    F -->|No| G([Stop; preserve JD])
    F -->|Yes| H[Send JD and approved public-safe facts]
    E -->|Cost within threshold| H
    H --> I[Model suggests role-family tags and drafts]
    I -->|Malformed or model failure| J([Error; preserve JD and drafts])
    I --> K[User reviews and confirms tags]
    K -->|Change tags| L[Regenerate with confirmed tags]
    L -->|Failure| J
    L --> K
    K -->|Tags confirmed| M[Save unapproved resume and cover letter]
    M --> N([Continue to verification])
    classDef ai fill:#dbeafe,stroke:#2563eb,color:#1e3a8a
    classDef system fill:#e5e7eb,stroke:#6b7280,color:#1f2937
    classDef user fill:#fef3c7,stroke:#d97706,color:#78350f
    classDef success fill:#dcfce7,stroke:#16a34a,color:#14532d
    classDef error fill:#fee2e2,stroke:#dc2626,color:#7f1d1d
    class A,B,C,F,K user
    class D,E,H,L,M system
    class I ai
    class G,J error
    class N success
```

### Inline citations

Trigger: a `verified` or exported draft is found to contain an unsupported number or claim.

- Drafts (`resume.md`, `cover-letter.md`, never the `.docx`) carry inline citation markers pointing to a row in `master/metrics-log.csv`.
- `metrics-log.csv` first gains a stable `id` column; row numbers shift when rows are added.
- `verify-claims` checks each marker against its row and flags claims not yet in the log. No new script.
- `build.sh` strips the markers before export (a filter rule in the existing script).

### Later phases

- **Assisted submit:** a script that opens the application page and pre-fills fields using the `job-application-agent:application-form` plugin skill, with the user clicking submit. Assess job-board terms and account risk before implementation; full autopilot is not a goal.
- **Web app:** only if the CLI is the bottleneck. A local review/export UI over the same folder structure; hosting would mean resume data leaves the machine and would require a separate privacy decision.
- **Job feed:** saved-search email alerts parsed into a job list, reviewed by hand, each handed to `tailor.sh` one at a time (~~`jobs.txt` for batch~~).

## Risks & Open Questions

| Risk / Question                                                | Severity | Mitigation                                                                                                                                        | Status  |
| -------------------------------------------------------------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| LLM fabricates or inflates claims                              | High     | ~~FR5 gate, deterministic number check, human approval~~ `verify-claims` gate, recorded overrides (`verify_skipped`), `claims_caught` monitoring, human approval; citations behind a trigger | Open    |
| Model API receives content not approved for external use       | High     | ~~Send only the reusable, user-approved public-safe fact allowlist and displayed JD payload; never send private master content~~ V1: Claude Code may read repo files except `.env`; output never carries private content. V2 keeps the allowlist. | Decided |
| ~~Cost exceeds expected USD 0.50 per application~~             | Low      | Moved to [V2](#v2-not-built)                                                                                                                      | V2      |
| Auto-apply violates job board terms                            | High     | Non-goal in V1; assisted submit only                                                                                                              | Decided |
| ~~Specific open-weight model and API endpoint~~                | Low      | Moved to [V2](#v2-not-built)                                                                                                                      | V2      |
| ~~Provider compatibility or retention terms differ~~           | Medium   | Moved to [V2](#v2-not-built)                                                                                                                      | V2      |
| Whether tailored applications improve recruiter response rates | Medium   | ~~Defer outcome analytics; decide whether to track callbacks after the core workflow is proven~~ Track `outcome_rating` in `quality-log.csv`      | Decided |
| Verify gate can be overridden with `skip`                      | Medium   | Keep for false positives; record every use as `verify_skipped`                                                                                   | Decided |
| Separate Claude session per skill, or bundle skills in one session? | Low | Undecided. `tailor.sh` opens one session per skill, with no recorded reason. Separate sessions could give `verify-claims` fresh context; one session shares context and avoids restarts. Today is mixed: `resume-orchestrator` runs `verify-claims` in its own session, and `tailor.sh` step 4 then skips a `verified` row. | Open |
| Agents can set `ready` or `exported`; only `AGENTS.md` forbids it | Medium | `set-status.sh` accepts both from any caller, and `.claude/settings.json` denies only `Read(./.env)`. Add a deny rule if the rule needs enforcing. | Open |
| A redraft overwrites an uncommitted `resume.md`                 | Medium | Git replaced revisions, but nothing commits before submit. Commit before re-running a skill. | Open |
| GitHub handle is committed, while README says links never live in the repo | Low | `carriegale2710` is in README plugin commands and `.claude/settings.json`. Repo stays private; accept it or reword the README. | Open |

## Assumptions Made

- Solo user, Windows with Git Bash~~, Python 3 is available for the CLI,~~ and existing Bash scripts remain the setup/build layer.
- The existing skills are good enough to start; tuning them comes after measurement.
- ~~The CLI is the V1 interface~~ `tailor.sh` is the V1 interface; docx export is a separate command after content approval.
- Any future daily-volume target refers to prepared applications, with submission done by hand.
