# Issues

Open problems found in the repo review (2026-11-02). Tick when fixed.

- [x] **`verify-report.md` contradiction.** `docs/MVP.md` marks it done, the README says "not built yet", and the `verify-claims` skill never writes a file. Fix: either make `verify-claims` write `applications/<folder>/verify-report.md`, or remove it from the MVP done-when list and the README.
