---
name: improve-master
description: Audit master/master-resume.md and its side files (metrics log, skills inventory, archive) for gaps (TODOs, unproven metrics, unresolved conflicts, unset skill markers, missing recent work), then run a short one-question-at-a-time interview to surface and record the missing facts. Use when asked to improve, review, maintain or update the master resume. Not for tailoring to a job.
---

# Improve master

Inputs: `master/master-resume.md`, `master/metrics-log.csv`, `master/skills-inventory.csv`, `master/archive.md` (maintenance checklist and Archive). Read `references/master-resume-practice.md` first.

The user asking to run this skill is the explicit request to edit `master/`. Everything else in `AGENTS.md` still applies: no invented facts, `TODO` stays `TODO` until the user supplies the fact, contact placeholders stay as written, never read `.env`, never run the docx build.

## 1. Audit (no questions yet)

Build a gap list from the master using the "Gaps this repo should check" list in the reference. Rank by what blocks the most applications:

1. `master/metrics-log.csv` rows with unproven numbers or `TODO` evidence.
2. Unresolved conflicts with older CVs (master section 6).
3. `TODO` facts in roles and projects (dates, team size, stack, links).
4. Unset skill levels in `master/skills-inventory.csv` and skills no bullet evidences.
5. Missing STAR stories (interview-story `TODO`s in master section 6).
6. Recent work not in the master.

Show the user the top 5 gaps in one short list and let them pick, or start at the top. Do not ask about all of them.

## 2. Interview

One question at a time. Each answer decides the next question. Open from the gap type:

- **Fact gap** (TODO, conflict): "What is the correct value for X, and what proves it?" Never ask about project dates, years or deployment dates, and never add them: the master's section 4 rule is that projects do not need dates.
- **Number gap** (`master/metrics-log.csv`): "How was this measured, against what baseline, and where is the evidence (PR, CI run, dashboard, email)?"
- **Skill gap** (inventory or missing bullet): "Where did you last use X, and what did you build or fix with it?"
- **Recent work**: "What have you done in the last month or two that is not in the master?"

Branch on the answer:

- **Direct and specific:** probe scale, role, tools, production or practice, the problem, the outcome, and the evidence.
- **Partial or indirect:** ask what the user's part was and what they learnt. Record it as supporting work only if it was substantial.
- **Vague:** reframe with a concrete prompt ("what was the last ticket you closed using it?").
- **Personal, course or volunteer:** check recency, scope and any measurable result.
- **None:** ask once about the wider category, then move on.

Style:

- Do not repeat what the user has already said. Refer back: "Earlier you mentioned...".
- Verbose user: ask for the key takeaway. Terse user: offer two or three examples to pick from. Unsure user: validate, then give a prompt.
- After 2-3 unproductive attempts on a gap, leave it as `TODO` and move on. Never push the user to produce content or guess a number.
- Keep each session short. Stop when the picked gaps are done or the user says stop.

## 3. Propose, then write

After each gap, show the proposed edit as a small diff-style block: location in the master, old text, new text.

- A new or changed bullet follows what + how + why, past tense, with the right tags.
- Every number gets a `master/metrics-log.csv` row in the same edit: claim, where used, type (Fact, Estimate, Projection, Self-reported, Unverified, Conflict), source, date, safe wording. Type is Fact only when the user supplied the evidence. If not, record the evidence as `TODO` and keep the type honest.
- A resolved conflict updates the master text and removes that item from the conflicts list in master section 6.
- Replaced or retired bullets move to the "Archive" section of `master/archive.md`, not the bin.
- NDA items (Outlier / Scale AI) stay generic.

Apply only edits the user confirms. Nothing from the interview goes into the master on inference.

## 4. Close

- Tick the `master/archive.md` maintenance checklist items that were actually done. Do not tick others.
- Suggest the next review date from that checklist's cadence.
- Report, as `AGENTS.md` requires: what was cut or archived, what was reworded, and every claim that still needs evidence.
- Offer to run `verify-claims` on any tailored resume that used a changed claim. Do not change tracker status.
