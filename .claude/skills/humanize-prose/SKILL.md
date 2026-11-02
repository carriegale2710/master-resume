---
name: humanize-prose
description: Remove AI writing patterns from prose-heavy application documents (cover letters, cold emails, application form free-text answers, LinkedIn About) so they read as written by the candidate. Use after job-application-agent:cover-letter or similar, before verify-claims. Never use on resume.md.
---

# Humanize prose

## Scope

- Use on: `applications/<folder>/cover-letter.md`, cold emails, free-text application answers, LinkedIn About text.
- Never use on `resume.md` or any resume bullets. Resumes follow the bullet rules in `AGENTS.md` and are checked by `job-application-agent:application-lint` instead. If asked to humanize a resume, say so and stop.

## Rules

Follow `AGENTS.md`. These win over any general humanizing advice:

- Edit wording only. Never add, infer or change a fact, number, tool, date, title, employer or outcome. Every claim in the output must already be in the input.
- Never add invented anecdotes, quotes, studies or opinions to "add personality".
- Keep `${...}` placeholders and `TODO` markers exactly as written.
- Australian English spelling.
- Keep a professional, plain tone. No slang, no fake casualness, no emoji.
- First person is fine in a cover letter; keep it specific ("I built", not "I am passionate about").

## Patterns to fix

1. Inflated significance: "pivotal", "testament", "plays a key role", "marks a shift", "evolving landscape".
2. Tacked-on -ing clauses: "..., ensuring", "..., highlighting", "..., contributing to".
3. Promotional words: "passionate", "thrilled", "dynamic", "cutting-edge", "seamless", "robust", "world-class".
4. AI vocabulary: "additionally", "delve", "leverage", "foster", "showcase", "underscore", "align with", "crucial", "valuable".
5. Copula avoidance: "serves as", "stands as", "boasts" -> "is", "has".
6. Negative parallelism: "not just X, but Y", "it's not about X, it's about Y".
7. Forced groups of three and synonym cycling.
8. Em dashes: replace with commas, full stops or brackets.
9. Filler and hedging: "in order to", "I believe that I could potentially", "it is worth noting".
10. Chatbot leftovers and stock openers/closers: "I am writing to express my interest", "I hope this finds you well", "Thank you for considering my application" padded with more of the same.
11. Generic upbeat endings: "I look forward to contributing to your exciting journey".
12. Same-length sentences throughout: vary rhythm, mixing short and longer sentences.

## Workflow

1. Read the target file and the job description in the same application folder.
2. List the patterns found, with line numbers.
3. Rewrite the affected sentences only. Leave sentences without patterns alone.
4. Self-check: "What still reads as AI-written?" Fix what remains.
5. Confirm no fact was added or removed by comparing claims before and after.
6. Show the user the changes before writing them, unless they asked you to apply them.
7. Hand off to `verify-claims`. It stays the final step.

## Output

The revised text, then: patterns fixed, sentences left unchanged on purpose, and any claim that still needs evidence.

Pattern list adapted from Wikipedia: Signs of AI writing (WikiProject AI Cleanup).
