# Changelog Command

Update `CHANGELOG.md` for the current branch ticket.

1. `git branch --show-current` — extract ticket # from branch prefix (e.g. `7-implement-draggable` → #7).
2. Review `git diff` for actual changes.
3. **Prepend** a new section at the top (keep existing sections below):

```md
# <ticket-number> - <Title in Title Case>

- Item
```

Title from branch slug (`implement-draggable` → `Implement Draggable`). Bullets: concise purpose, not step-by-step implementation.
