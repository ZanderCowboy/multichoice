# Feature Command

Implement new functionality from a GitHub issue number or URL.

**Follow [\_workflow-base.md](_workflow-base.md) for shared steps.**

## Input

Issue number (`#12`), issue URL, or PR URL describing the feature. If missing, ask before starting.

## Process

1. **Fetch ticket** — `gh issue view <n|url> --json number,title,body,labels,url,state`. Issue is source of truth; do not guess missing behavior.
2. **Confirm feature** — If bug-only, test-only, or refactor, suggest `/fix` or `/test` instead.
3. **Plan briefly** — Requirements, likely files, tests, validation. Stop for confirmation if new architecture, dependency, or breaking change is needed.
4. **Implement** — UI in app presentation; logic in `packages/core`; models in `packages/models`; reusable UI in `ui_kit`/`theme`. Match look and feel of nearby screens.
5. **Tests** — Add/update behavior tests; mirror existing structure.
6. **Respond** — Issue # and title; behavior changes; follow-ups; validation performed.

## Decision rules

- Proceed without extra questions when the issue is detailed and fits existing patterns.
- Present options when multiple paths materially affect architecture or UX.
- Do not create unrelated refactors.
