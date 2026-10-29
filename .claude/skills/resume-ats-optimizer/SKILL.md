---
name: resume-ats-optimizer
description: Review resume formatting and evidence-backed keyword alignment for applicant tracking systems
---

# Resume ATS Optimizer

## Source-of-truth rules

Follow the repository's `AGENTS.md` and evidence rules before using this skill. `master/master-resume.md` is the only source of facts. Never invent or infer skills, tools, experience, dates, titles, metrics, or outcomes. Use job-description terminology only when the master supports the claim. Treat `TODO` as unknown, and follow `master/metrics-log.csv` safe-wording rules for numbers. Examples in this skill are illustrative only and must not be reused as facts or claims.

## When to Use This Skill

Use this skill when the user wants to review a resume's parsing-friendly formatting or compare supported resume content with a job description.

## Formatting Review

Check for practical readability and parsing concerns, such as:

- Whether the document is text-based and its content can be selected.
- Tables, columns, text boxes, images, or graphics that may interfere with text order.
- Clear, consistent section headings and date formats.
- Contact information presented as readable text.
- A file format accepted by the employer.

Describe observed issues and offer appropriate alternatives. Do not claim that a format guarantees a particular screening outcome.

## Evidence-backed Keyword Review

1. Identify key requirements and terms in the job description.
2. Check whether each term or a supported equivalent appears in the master.
3. Report terms that are present, missing, or not supported by the master.
4. Suggest placements or wording changes only for claims supported by the master.
5. Do not add a skill or keyword just to match the posting.

Report a transparent list of matched and unsupported requirements rather than a predictive ATS score, pass/fail result, or ranking.

## Analysis Output

```markdown
# RESUME COMPATIBILITY REVIEW

## Formatting observations
- [Observed issue and practical suggestion]

## Job requirements and evidence
- Supported in master: [Requirement and source-backed experience]
- Not found in master: [Requirement; do not add as a claim]
- Needs clarification: [Unknown or TODO evidence]

## Suggested edits
- [Evidence-backed change, or "No changes recommended"]
```

## General Guidance

- Use clear section headings and simple, consistent formatting.
- Use job-description terminology naturally when the master supports it.
- Do not keyword-stuff or imply proficiency that the source does not establish.
- Distinguish a formatting observation from a prediction about an employer's screening system.
- Follow `AGENTS.md` for application paths, privacy, wording, and final claim verification.
