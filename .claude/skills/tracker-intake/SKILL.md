---
name: tracker-intake
description: Extract company, role, location, source and opening/closing dates and eligibility criteria from applications/<folder>/job-description.md and fill the empty columns of that application's pending row in applications/tracker.csv. Use right after the job description is pasted, before resume-tailor-quick.
---

# Tracker intake

Inputs: `applications/<folder>/job-description.md`, `applications/tracker.csv`. Never read `master/` or `.env`.

1. Find the row whose `id` equals `<folder>`. If none, stop and tell the user to run `bash scripts/new-application.sh company-role`.
2. Read the job description. Extract only what the text states:
   - `company`: employer name (replaces the folder slug placeholder).
   - `role`: job title as posted.
   - `location`: city/state and work mode (remote, hybrid, on-site), as posted.
   - `source`: original job posting URL, copied exactly from the `URL:` line. Empty if that line is empty.
   - `opening_date`: posted/opening date, `YYYY-MM-DD`. Use the `Date posted:` line if filled.
   - `closing_date`: closing/apply-by date, `YYYY-MM-DD`.
   - `eligibility`: short summary of the posting's stated criteria (qualifications; experience; working rights; location; availability), joined with `; `. Copy what the posting says; do not judge the user against it.
3. Edit the row in place with Edit. Rules:
   - Fill only empty cells, except `company` (overwrite the slug). Never change `id`, `version_folder` or `status`; set `last_update` to today.
   - Leave `date_applied`, `contact`, `outcome`, `notes` untouched. `date_applied` is the submission date, not the posting date.
   - Unknown or not stated: leave the cell empty and list it in the report. Never guess a date or infer a location.
   - No commas inside values (use `;`). `scripts/set-status.sh` splits on plain commas.
   - Keep exactly 15 columns per row.
4. Also copy the dates into `Date posted:` and `Closing date:` in the job description file if those lines are empty.
5. Report: the final row, and every cell left empty because the posting did not say.

Next step: `resume-tailor-quick`.
