# Resume repo: agent rules

This file is the canonical, tool-neutral instruction set. Any agent working in this repo must follow it.

## Source of truth

- `master/master-resume.md` is the only source of facts. Never invent or infer a skill, tool, date, title, metric or outcome.
- Numbers are valid only if `master/metrics-log.csv` lists them. Rows marked **Estimate**, **Projection** or **Self-reported** must use the "Safe wording" column unless the user says the evidence is ready.
- Skills reference: `master/skills-inventory.csv` (Strong, Proficient, Weak / exposure only). Never lead with Weak / exposure only. A skill no master bullet evidences is a `TODO`.
- Anything marked `TODO` is unknown. Flag it; never fill it in.

### Master write-back

When any skill asks the user a question (gap interview, interview prep, cover letter, feedback) and they confirm a new fact (experience, tool, outcome, number, story, date), add it to `master/` before using it anywhere:

- Facts: `master/master-resume.md`, in the right section, with tags. Record raw facts in the user's words, not polished bullets.
- Numbers: a new `master/metrics-log.csv` row with Type and source. Unproven numbers are Self-reported or Estimate and get a Safe wording.
- Skills: `master/skills-inventory.csv`, at the level the evidence supports. No skill goes above Weak / exposure only without a master bullet.
- STAR stories: `master/stories.md` (create it with the first story).

Use `job-application-agent:master-resume` for the edit. Show each edit as file, section, old, new; write only what the user confirms. Unknown parts stay `TODO`. Then use the fact in the application file, under the privacy rules below.

## Privacy

- Never copy content from master section 6 (private constraints), `master/metrics-log.csv` (numbers only as evidenced, worded per "Safe wording"), `master/narrative-notes.md` (may inform cover letters and interview prep, rewritten; never a resume) or `master/archive.md` into a resume or cover letter.
- Respect the Outlier / Scale AI NDA note: use generic wording for tools and project types unless the user confirms otherwise.
- Never upload or paste this repo's private files into external services other than the agent session you are running in. That session may read any repo file except `.env`; private content must still never reach the output.
- Contact details are secret. Leave `${RESUME_NAME}`, `${RESUME_EMAIL}`, `${RESUME_LOCATION}`, `${RESUME_PHONE}`, `${RESUME_WORKRIGHTS}`, `${GITHUB_URL}`, `${LINKEDIN_URL}` and `${PORTFOLIO_URL}` placeholders exactly as written; they are intentional, not `TODO`. Never read `.env`, never ask for or write the real values, and never run the docx build (the user runs it locally so `.env` is filled in then).

## Writing rules

- Tailored resumes go in `applications/<YYYY-MM-company-role>/resume.md`. Never edit `master/` unless explicitly asked or for master write-back.
- Length: aim for one page; two pages is the hard maximum. Use the 5-7 strongest bullets per role family and cut older leadership items first.
- Mirror a job posting's keywords only where the master supports them.
- Plain, specific, past-tense bullets. No filler adjectives. Australian English spelling.
- Do not use tag names (`fullstack`, `qa`, etc.) in final output.
- Projects carry no dates or years (master section 4 rule). Add one only for a work in progress, and only if the master gives it. Never ask for or invent project or deployment dates.
- Tailoring workflow: follow `tailoring-rules/every-resume.md` (one target role, headline states stack, what+how+why bullets, no generic Skills section, graduate roles put Education & Training under the summary, fully typed links), then the matching role checklist in `tailoring-rules/by-role/` and, where they apply, `tailoring-rules/by-company/graduate.md`, `startup.md` and `industry.md`. Tick every item before calling a resume tailored. Where it conflicts with the privacy or source-of-truth rules above, those rules win.

## Cover letters

- Every cover letter an agent generates must be checked against `tailoring-rules/every-cover-letter.md` before it is called done. Tick every item, fix anything that fails, then re-check. Do not finish with an unticked item; report any item you could not fix.
- Where it conflicts with the privacy or source-of-truth rules above, those rules win.

## Tools in this repo

- `bash scripts/build.sh --tags a,b --md-only master/master-resume.md` filters master bullets by tag.
- `bash scripts/build.sh applications/<folder>/resume.md` builds the .docx (user-run only; it fills the header from `.env`).
- `bash scripts/new-application.sh company-role` creates an application folder.
- `bash scripts/tailor.sh` runs the whole tailoring flow interactively (user-run only; it opens Claude sessions and its last step runs the docx build, so agents never run it).
- Prefer these scripts over re-implementing their logic.

## Skills

Repo-specific skills live in `.claude/skills/<name>/SKILL.md`. General application skills come from the `job-application-agent` plugin (invoked as `job-application-agent:<skill>`). Typical order for an application:

1. `tracker-intake`
2. `resume-orchestrator` (runs `job-application-agent:job-ad-decoder`, `resume-drafter`, `job-application-agent:application-lint`, and other plugin skills as needed, then `verify-claims`)
3. `verify-claims` (mandatory final step before any file is called ready)
4. `job-application-agent:cover-letter` (optional), then `humanize-prose` on the letter (never on the resume), then `verify-claims` on the letter
5. `job-application-agent:interview-prep` (after applying)

Other repo skills live in the same folder; each `SKILL.md` description says when to use it.

### Plugin skills in this repo

The `job-application-agent` plugin assumes its own file layout. In this repo, read its paths as:

- `resume/master-resume.md` is `master/master-resume.md`. `resume/stories.md` and `resume/linkedin.md` are `master/stories.md` and `master/linkedin.md` (master write-back may create `master/stories.md`; create `master/linkedin.md` only when the user asks).
- `applications/<company>-<role>/` is `applications/<folder>/`. The ad is in `job-description.md`; `job-ad-decoder` writes `criteria.md` beside it.
- Numbers come from `master/metrics-log.csv` per the source-of-truth rules, not from the plugin's estimate rules.
- `applications/tracker.csv` is the tracker. Never create the plugin's `tracker.md`.
- Never run `job-application-agent:docx-export`; `scripts/build.sh` exports (user-run only).

Where a plugin skill conflicts with this file (page length, project dates, Skills section, tracker, privacy), this file wins.

## Always report

At the end of any task, list: what was cut, what was reworded, every claim that still needs evidence, and every master write-back edit (file, section).

## Tracker status

`applications/tracker.csv` status moves `pending` (new-application.sh) -> `tailored` (resume-drafter) -> `verified` (verify-claims, on PASS) -> `ready` (build.sh sets it when the user answers y at its approval prompt) -> `exported` (build.sh sets it after a docx build; rebuilding an `exported` row asks to confirm a re-export). Skills set their own status with `bash scripts/set-status.sh <folder> <status>` before finishing. The row `id` is the application folder name. Agents never set `ready` or `exported`.

<!-- caveman-begin -->

Respond terse like smart caveman. All technical substance stay. Only fluff die.

Rules:

- Answer first: Answer, then reason, then next step.
- Kill ceremony: No greeting, hedging, pleasantries, recap, or closer.
- Short word: "fix" not "implement a solution for".
- Articles optional, meaning never: Drop a/an/the when the sentence still reads in one pass.
- One idea per sentence: ASD-STE100 is the floor: 20 words max, active voice, imperative for instructions, one term per thing, pronoun only with an obvious referent.
- Payload verbatim: Code blocks unchanged.
- Tool runs: bounded status: No text between routine calls.
- User's language: Compress the style, not the language.
- Never perform caveman: No "caveman mode on", no "me think", no "Caveman:" prefix, no normal answer plus caveman copy.

Switch: /caveman (default), /ultracave (fragments, each fact once), /megacave (Classical Chinese 文言文)
Stop: "stop caveman" or "normal mode"

Auto-Clarity: plain prose for security warnings, irreversible actions, step order a fragment could scramble, user confused, questions you ask the user. Resume after.

Boundaries: code, comments, commits, PRs, docs written normal; existing comments kept unless asked.
Floor: code, commands, paths, numbers and error strings verbatim; never drop not/never/no/only.

<!-- caveman-end -->

Always use the ponytail skill/plugin when making design or architectural decisions in order to acheive the user's goals in to prevent unneccessary complexity.
