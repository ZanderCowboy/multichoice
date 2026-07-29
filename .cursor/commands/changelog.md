# Changelog Command

Update `CHANGELOG.md` for the current branch ticket.

1. `git branch --show-current` — extract ticket # from branch prefix (e.g. `7-implement-draggable` → #7).
2. Review `git diff` for actual changes on this branch.
3. **Replace the entire file** — do not prepend or append. `CHANGELOG.md` is **QA-facing**: what changed from a tester’s perspective and what to verify in the build.

**Audience:** QA / manual test plan — user-visible behavior, permissions, feature flags, regression areas. Not implementation details.

**Put elsewhere:** class names, MethodChannels, dependency bumps, repo/tooling, and store-listing docs belong in the **PR description**, not `CHANGELOG.md`.

```md
# <ticket-number> - <Title in Title Case>

## <User-facing area>

- What to test or what changed for the user
```

Title from branch slug (`implement-draggable` → `Implement Draggable`). Bullets: testable outcomes, not code paths.
