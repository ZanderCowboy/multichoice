# Fix Command

Fix a bug, regression, analyzer issue, failing test, or CI failure.

**Follow [\_workflow-base.md](_workflow-base.md) for shared steps.**

## Input

Issue number/URL, logs, stack trace, failing test output, or bug description. If none, check analyzer/linter first; ask what to fix if still unclear.

## Process

1. **Confirm fix scope** — If new feature or broad refactor, suggest `/feature` instead.
2. **Reproduce** — Run narrowest command that demonstrates the failure (single test, scoped analyze).
3. **Root cause** — Trace failing path; no speculative fixes or "while here" cleanup.
4. **Minimal fix** — Only code required to fix the issue; preserve architecture and local style.
5. **Regression test** — Add focused test when logic or user-facing behavior changed.
6. **Re-validate** — Re-run the failing command; then scoped test/analyze per workflow base.
7. **Respond** — Issue # if applicable; root cause; validation; remaining risk.

## Minimal change rules

- No unrelated formatting, refactors, or behavior changes outside the failing case.
- If a minimal fix is impossible, stop and explain why.
