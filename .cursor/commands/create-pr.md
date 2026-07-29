# Create PR Command

Commits must exist first (use `/commit` if needed).

## Process

1. `git status` — branch name, clean working tree, remote tracking.
2. Push: `git push -u origin HEAD` if new branch, else `git push`.
3. Create draft PR via `gh pr create --draft`.

## Project defaults

- **Base**: `develop` unless user specifies another base (e.g. `--base 7-feature-branch`).
- **Assignee**: `ZanderCowboy`
- **Labels**: `breaking`, `bug`, `dev-ops`, `documentation`, `enhancement`, `feature`, `performance`, `refactor`, `testing` — pick from branch/type.
- **Title**: `<issue-number> <Title>` — extract # from branch (e.g. `7-implement-x` → `7 Implement X`).
- **Body**: `#<issue-number> <summary>`, changes, testing, optional screenshots table.

## Branch flow

- Features → `develop` (default)
- RC → `rc` only if requested
- Production → `main` from `rc` only if requested

Return PR URL when done.
