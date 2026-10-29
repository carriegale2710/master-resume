---
name: resume-quantifier
description: Identify evidence-backed opportunities to quantify resume achievements
---

# Resume Quantifier

## Source-of-truth rules

Follow the repository's `AGENTS.md` and evidence rules before using this skill. `master/master-resume.md` is the only source of facts. Never invent, infer, calculate from unverified inputs, or estimate a metric for application content. A number may be used only when it is supported by `master/metrics-log.csv`, with the required safe wording for estimates, projections, or self-reported entries. Treat `TODO` as unknown.

If an applicable metric is not in the master, ask the user questions to locate supporting evidence. Do not add the answer to an application until the evidence is recorded in the master and complies with its rules. If evidence is unavailable, omit the metric and retain a factual, non-quantified description.

## When to Use This Skill

Use this skill when the user wants to identify evidence-backed metrics for resume bullets or asks how to quantify their work.

## Metric Discovery

For each relevant experience, ask questions that may help locate existing evidence:

- What scope or volume is recorded in the master?
- Is there a documented before-and-after result?
- Is a budget, timeframe, team size, or customer count recorded?
- Does `master/metrics-log.csv` specify safe wording or mark the figure as an estimate, projection, or self-reported?

Potential metric categories include money, time, percentages, volume, quality, and frequency. These are prompts for searching the source, not permission to infer or calculate a claim.

## Workflow

1. Review the relevant experience in `master/master-resume.md` and its rows in `master/metrics-log.csv`.
2. Identify claims already supported by the master and preserve any required safe wording.
3. Ask the user focused questions only when they could help find or verify evidence for an existing master entry.
4. Flag missing evidence or `TODO` entries; never fill them in.
5. Use supported metrics where relevant. Otherwise, write the bullet without a metric.
6. Check the final application content against `AGENTS.md` and the master.

## Output Format

```markdown
# RESUME QUANTIFICATION

## Supported Opportunities
- [Existing master evidence and a relevant way to use it]

## Questions to Locate Evidence
- [Question, if needed; do not state an unverified answer as fact]

## Metrics Omitted
- [Unknown or unsupported metric and the evidence still needed]

## Evidence-safe Bullet
- [Bullet using only supported facts, or a non-quantified factual version]
```

## Quality Checklist

- Every factual claim is supported by the master.
- Numbers follow `master/metrics-log.csv` and use required safe wording.
- Unknowns and `TODO` entries are flagged, not filled in.
- Unsupported metrics are omitted; no metric is required when none applies.
- The final bullet describes the user's contribution without exaggeration.
