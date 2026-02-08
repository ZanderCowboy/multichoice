Create a pull request by pushing the branch and creating the PR with appropriate labels and description.

**Note**: Commits should already be created. If you need to create commits, use `.cursor/commands/commit.md` first.

## Process

1. **Check git status** to understand the current state:
   - Verify current branch name
   - Check if branch exists on remote
   - Verify all changes are committed (no uncommitted changes)

2. **Push the branch** to remote:
   - If branch doesn't exist on remote: `git push -u origin <branch-name>`
   - If branch already exists: `git push`
   - Verify push was successful

3. **Create the Pull Request**:
   - **Target branch**: `develop` (default for feature branches)
   - **Create as draft**: ALWAYS create PRs as drafts using `--draft` flag
   - Use GitHub CLI if available: `gh pr create --draft`
   - Or provide instructions for manual PR creation (mark as draft)

4. **PR Details**:
   - **Title**: MUST include issue number and branch name in format: `<issue-number> <Title>`
     - Extract issue number from branch name (e.g., `7-implement-draggable-retry` → issue `7`)
     - Convert branch name to title format: remove prefixes (`feature/`, `fix/`, etc.), replace hyphens with spaces, capitalize words
     - Format: `<issue-number> <Title>`
     - Example: Branch `7-implement-draggable-retry` → Title: `7 Implement Draggable Retry`
     - Example: Branch `12-fix-auth-token` → Title: `12 Fix Auth Token`
     - If branch doesn't have issue number, ask user for it
   - **Description**: Include:
     - Summary of changes
     - What was changed and why
     - Any breaking changes
     - Testing performed
     - Related issues (if any)

5. **After PR creation**:
   - Show the PR URL or number
   - Display a summary of commits included
   - Remind that PR is created as draft and user can update it
   - Remind about adding version label if not already added

## Important Rules

- **All changes must be committed** - never create a PR with uncommitted changes
- **Default target branch is `develop`** - only target `rc` or `main` if explicitly requested
- **PR title MUST include issue number and branch name** - format: `<issue-number> <Title>` (e.g., `7 Implement Draggable Retry`)
- **ALWAYS create PRs as drafts** - user will update the PR before marking as ready
- **Verify branch is up to date** - check if remote branch exists and is in sync

## Branch Workflow

- **Feature branches** → `develop` (default)
- **Release candidates** → `rc` (requires explicit request)
- **Production releases** → `main` (from `rc` branch only)

## Example Workflow

```bash
# 1. Check status
git status
git branch -vv

# 2. Push branch
git push -u origin feature/my-feature

# 3. Create PR as draft
# Example: Branch is "7-implement-draggable-retry"
gh pr create --draft --base develop --title "7 Implement Draggable Retry" --body "Description of changes..." --label patch
```
