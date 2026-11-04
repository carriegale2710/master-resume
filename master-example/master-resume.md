# MASTER RESUME (source of truth: never submit this directly)

> **Use:** `bash scripts/new-application.sh company-role`, filter bullets by tag, cut to one page (two pages maximum), tick `tailoring-rules/every-resume.md`, export as **.docx**.
> **Rules:** Edit facts here only. Every number needs a row in `master/metrics-log.csv`. Fill every `TODO` before reusing a claim. Swap unproven numbers for the safe wording.

**Tag key:** `fullstack` `backend` `frontend` `qa` `ux` `a11y` `ai-eval` `devops` `product` `leadership` `security` `research` `ecommerce` `startup` `retail` `customer-service`
**Variant key:** **S** = short one-liner, **M** = standard, **Q** = quantified

> Template: delete this note, keep the structure. Each `TODO` is unknown; never guess it. Edit the tag key above to match `master/tags.md`.

---

# Maintenance (private; never on a resume)

## Maintenance checklist

- [ ] Within 1 week of finishing anything: add bullets, tags, and metrics evidence
- [ ] Monthly (10 min): add new work, check links, update demo URLs
- [ ] Quarterly: move stale material to an Archive section
- [ ] Commit after every change (or save a dated copy)
- [ ] Before exporting any tailored CV: follow `tailoring-rules/every-resume.md`

---

## 0. Header and admin facts

Leave the `${...}` placeholders exactly as written. `scripts/build.sh` fills them from `.env` at docx build time.

- Name: ${RESUME_NAME}
- Location: ${RESUME_LOCATION}
- Phone / Email: ${RESUME_PHONE} / ${RESUME_EMAIL}
- LinkedIn / GitHub / Portfolio: ${LINKEDIN_URL} / ${GITHUB_URL} / ${PORTFOLIO_URL}
- Work rights / visa status: ${RESUME_WORKRIGHTS}
- Languages: TODO

### Headline options

- **TODO variant name:** TODO headline that states the role and stack, e.g. Junior Full-Stack Developer | React, TypeScript, SQL

### Summary variants

- **TODO variant name:** TODO 2-3 sentence summary. Only facts from sections 2-5.

**Optional add-on lines (one per CV at most):**

- **TODO add-on name:** TODO one line.

---

## 1. Skills inventory (reference only; not a CV section)

**Main tech stack** (strongest first, not exhaustive): TODO. For full skills inventory list, see `skills-inventory.csv`.

---

## 2. Education & Training

### TODO Institution, TODO Qualification

- TODO Location | TODO Mon YYYY – Mon YYYY | TODO major, grade
- `tag` TODO what you studied or built, and why it matters.

### Certifications

#### TODO Provider, TODO Certificate

- TODO Mon YYYY – Mon YYYY | `tag`

---

## 3. Work experience

### TODO Employer, TODO Job title

TODO Location | TODO Mon YYYY – Mon YYYY | Team size: TODO | Stack/Tools: TODO
Links: TODO

**One-liners:**

- **S:** TODO one-line summary of the role.

**Bullets:**

- `tag` `tag` TODO what you did, how, and why it mattered (past tense, specific). Raw facts in your own words are fine; polish happens per application.
- `tag` TODO bullet with a number. Add a row to `master/metrics-log.csv` and mark the bullet _(estimate; see Metrics Log)_ or _(self-reported; see Metrics Log)_ if unproven.

### Earlier roles: retail, hospitality and customer service (`optional: use for retail/customer-service applications; otherwise drop`)

#### TODO Employer, TODO Job title

TODO Location | TODO Mon YYYY – Mon YYYY

- `tag` TODO bullet.

---

## 4. Projects

> **Rule:** no dates or years on projects. Add one only for a work in progress, and only if given here.

### TODO Project name | TODO type, e.g. Full-Stack Web Application

Role: TODO | Team: TODO
Stack: TODO
Live: TODO | Repo: ${GITHUB_URL}/TODO

**One-liners:**

- **S:** TODO one-line summary.

**Bullets:**

- `tag` TODO what you built, how, and why.

> Unfinished projects: say so here. Never describe them as complete or deployed.

---

## 5. Leadership, programs and activities

> **Graduate roles:** put section 2 plus any programs below together under "Education & Training" directly below the summary.

### TODO Program or organisation, TODO Role

TODO Location | TODO Mon YYYY – Mon YYYY

- `tag` TODO bullet.

### Awards

- TODO award: what it recognised.

---

## 6. Private constraints and evidence (NEVER on a resume)

- **Metrics evidence:** `master/metrics-log.csv`. Every number on a CV needs a row; Estimate, Projection and Self-reported rows use the Safe wording column.
- **Narrative material:** `master/narrative-notes.md` (personal story, differentiators, likely objections, target industries).
- **Retired content and the maintenance checklist:** `master/archive.md`.
- **Applications:** `applications/tracker.csv`.

- **NDA or confidentiality limits:** TODO what you may and may not name (employer, client, project, tools).
- **Eligibility-only facts (e.g. WAM):** TODO quote only when an application form asks. Never on a resume or cover letter.
- **Date overlaps:** TODO explain any roles or programs whose dates overlap.
- **Interview stories (STAR):** TODO one each for your strongest projects. Later stories go in `master/stories.md`.
- **Anything discussable but not publishable:** TODO.
- **Third-party evidence (reference letters):** TODO what the referee said, who they are, and whether they agreed to be listed. Use for cover letters and interviews, never as resume adjectives.
- **Do not claim:** TODO claims you must not make (unmeasured coverage, unevidenced tools, wrong durations).

### Conflicts between this master and older CVs (resolve once, then delete this list)

TODO
