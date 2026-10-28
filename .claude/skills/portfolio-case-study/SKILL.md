---
name: case-study
description: Write tight, recruiter-friendly software engineering case studies for portfolios from project repo documentation or resume project bullet points.
---

# Case Study Writer (2026 Best Practices)

## When to Use This Skill

Use this skill when the user:

- Wants to create portfolio case studies
- Needs to expand resume bullets or github readmes into detailed writeups
- Is building a portfolio website
- Wants to showcase project work in depth
- Wants to create or improve portfolio case studies for software engineering roles
- Needs to frame university/capstone projects as professional work
- Mentions: "case study", "portfolio", "project writeup", "work samples", "portfolio piece"

## Core Capabilities

- Transform resume bullets or github repos into detailed case studies
- Structure case studies for maximum impact
- Create compelling project narratives
- Balance technical detail with business context
- Format for portfolio websites
- Tailor depth to audience

## Case Study Purpose

**Why Case Studies Matter:**

- Resumes show WHAT you did; case studies show HOW and WHY
- Demonstrate thinking process, not just outcomes
- Allow deeper showcase of skills
- Differentiate you from other candidates
- Required for many PM, UX, and creative roles

## Core Principles

**What hiring managers actually look for:**

- Proof you can ship working software, not just finish courses
- Clear problem, your approach, trade-offs, and outcomes
- 2–4 minute read max; skimmable in under 30 seconds
- Evidence of judgment: trade-offs, challenges, and what you'd do differently

**Treat projects like real products:**

- Lead with the problem and users, not the course or subject
- Describe constraints like a real engagement (timeline, deployment, stakeholders)
- Quantify impact where possible (users, requests, performance, test coverage)
- Use professional language: "stakeholders", "requirements", "deployment", not "assignment", "marks"
- Show artifacts that mirror industry work: PRD, EER diagram, deploy guide, user flows, test directory — exactly what you already have.

## Output Structure (Recruiter-Friendly)

Produce a case study with these sections, in this order:

### 1. One-Line Pitch (Top of Page)

A single sentence that tells a skimming recruiter what this is and why it matters.

**Template:**

> "A [stack/type] system that enables [users] to [core capability] with [key differentiator]."

**Example:**

> "A Flask-based library management system that enables staff to catalogue, search, and assess Indigenous resources with role-based access and structured metadata."

### 2. Quick Facts (Bulleted Header)

- **Role:** Your role (e.g., "Full-stack developer (primary implementation)")
- **Project type:** What it is (e.g., "Web application for managing a library of Indigenous resources")
- **Stack:** Key technologies (e.g., "Python (Flask-style), SQL, HTML/CSS/JS, Heroku-style deployment")
- **Timeline:** Duration and context (e.g., "10-week capstone project")
- **Team:** Individual or team size and your specific ownership
- **Links:** Live demo (or video walkthrough) + GitHub repo

### 3. Problem (2–4 Sentences)

Who had the problem, why it mattered, and what success looked like.

**Include:**

- Users/stakeholders
- Pain points or gaps
- Goal or success metric

**Example:**

> "Library staff struggled to maintain a structured, searchable catalogue of Indigenous resources with consistent metadata and access control. The goal was to deliver a system that centralised resource management, enforced role-based permissions, and supported assessment workflows tailored to the domain."

### 4. Approach & Key Decisions (3–5 Bullets)

For each decision, include: choice, alternatives considered, and trade-off accepted.

**Template per bullet:**

- "Chose [X] over [Y] to [benefit]; accepted [trade-off] in exchange for [gain]."

**Examples:**

- "Chose a monolithic Flask app over a microservice architecture to ship within a 10-week timeline; accepted tighter coupling in exchange for simpler deployment and faster iteration."
- "Used server-rendered templates instead of a separate SPA to reduce complexity; accepted slower client-side interactions for faster initial page loads and simpler hosting."
- "Implemented custom decorators for authorization to centralise access control; accepted additional abstraction layer in exchange for reduced duplication across views."

### 5. Challenges & Solutions (2–3 Bullets)

Real technical or product hurdles and how you resolved them. This shows you can handle messy, real work.

**Template per bullet:**

- "[Problem] → [What you tried] → [What worked] → [Result/improvement]."

**Examples:**

- "Initial schema caused N+1 queries on the catalogue page → added eager loading and denormalised summary fields → cut page load from ~1.2s to ~350ms in local testing."
- "Role checks were duplicated across views → introduced custom decorators to centralise authorization → reduced boilerplate and improved consistency."
- "Forms had inconsistent validation logic → refactored to shared WTForms classes with custom validators → fewer edge-case bugs and clearer error messages."

### 6. Results (With Numbers Where Possible)

Quantify impact and scope, even if approximate or from local testing.

**Include:**

- Functional outcomes (what shipped)
- Scope metrics (entities, routes, forms, tests)
- Performance or quality metrics (load times, test coverage, feedback)

**Example:**

- "Delivered a working deployment with authentication, CRUD for resources, and assessment workflows."
- "Implemented 8 core entities in the EER model, 12 forms, and 20+ protected routes."
- "Tests cover critical auth and assessment flows; deployment configured via Procfile and environment variables."
- "Catalogue page load reduced from ~1.2s to ~350ms after query optimisation."

### 7. What I'd Do Differently (2–3 Bullets)

Honest reflections that show growth mindset and self-awareness.

**Examples:**

- "Start performance testing earlier; would add query profiling and load testing in week 3 instead of week 8."
- "Modularise with Flask blueprints from the start to make the codebase easier to scale."
- "Engage community stakeholders earlier to validate metadata and access rules against cultural protocols."

### 8. Visual Asset List (For Portfolio Page)

List the visuals to include on the portfolio page (not the images themselves):

- Screenshot: Login / Home
- Screenshot: Core feature (e.g., resource catalogue)
- Screenshot: Key form or workflow
- Diagram: Architecture or data model excerpt
- Optional: Before/after, mockup vs implementation

## Special Handling for University/Capstone Projects

When the project is from a course or capstone:

- **Lead with the problem and users**, not the subject code or unit name.
- **Frame constraints professionally:** "10-week timeline", "deployment to Heroku", "stakeholder check-ins every 2 weeks".
- **Use grades/feedback as proxy metrics if needed:** "Passed usability testing with 10 participants", "Received distinction for architecture and documentation".
- **Avoid academic language:** No "assignment", "marks", "teacher"; use "project", "requirements", "stakeholders".
- **Highlight industry-like artifacts:** PRD, EER diagram, deploy guide, user flows, tests, CI config.

## Role-Specific Emphasis

Tailor emphasis based on target role:

**Full-stack / Backend:**

- Data modelling, API design, auth, performance, deployment
- Trade-offs around architecture, database, caching, scaling

**Frontend / Product-minded:**

- UX decisions, component architecture, state management, accessibility
- User research, iterations based on feedback

**DevOps / Platform-leaning:**

- CI/CD, infra as code, monitoring, reliability, cost

## Quality Checklist

Before finalising, ensure the case study:

- ✅ Starts with a one-line pitch and Quick Facts
- ✅ Clearly states the problem and who it affects
- ✅ Includes 3–5 key decisions with trade-offs
- ✅ Has 2–3 challenges with concrete solutions
- ✅ Includes at least some numbers or measurable outcomes
- ✅ Has a "What I'd do differently" section
- ✅ Provides demo + repo links near the top
- ✅ Is skimmable in under 2 minutes (roughly 400–800 words)
- ✅ Uses professional language, not academic framing

## Output Format

Produce the case study in clean Markdown, ready to paste into a portfolio site:

```markdown
# CASE STUDY: [PROJECT NAME]

> [One-line pitch]

## Quick Facts

- **Role:** [...]
- **Project type:** [...]
- **Stack:** [...]
- **Timeline:** [...]
- **Team:** [...]
- **Links:** [Demo] | [Repo]

## Problem

[2–4 sentences]

## Approach & Key Decisions

- [Decision 1 with trade-off]
- [Decision 2 with trade-off]
- [Decision 3 with trade-off]

## Challenges & Solutions

- [Challenge 1 → solution → result]
- [Challenge 2 → solution → result]

## Results

- [Outcome 1 with numbers if possible]
- [Outcome 2 with numbers if possible]
- [Outcome 3]

## What I'd Do Differently

- [Reflection 1]
- [Reflection 2]

## Visual Asset List

- [Visual 1]
- [Visual 2]
- [Visual 3]
```

Use this structure by default; expand sections only if the user explicitly requests a longer, deep-dive version.
