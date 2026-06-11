# Commit Command

Create multiple small, logical commits. Never one large commit mixing unrelated changes.

## Exclusions

Never commit: `.cursor/plans/*.plan.md`, `debug-log-*.md`, secrets, `.env`.

## Grouping (most specific path wins)

| Layer | Paths | Message prefix |
|-------|-------|----------------|
| Platform | `apps/multichoice/android/**`, `ios/**` | `feat(android\|ios):` |
| Models | `packages/models/**` | `feat(models):` |
| Core | `packages/core/**` (bloc, repo, service) | `feat(<feature>):` or `fix(<feature>):` |
| App UI | `apps/multichoice/lib/**` | `feat(<area>):` or `refactor(<area>):` |
| Tests | `**/*_test.dart`, `**/mocks.mocks.dart` | `test(<scope>):` |
| Chore | `pubspec.yaml`, `melos.yaml`, `Makefile`, `*.yaml` | `chore:` |

## Process

1. `git status` — review all changes.
2. For each group with changes: `git add <files>`, commit with conventional message from actual diff.
3. Do not push unless asked.
4. Summary: `git log --oneline -N`.

Use `type(scope): description` — `feat`, `fix`, `refactor`, `test`, `chore`.
