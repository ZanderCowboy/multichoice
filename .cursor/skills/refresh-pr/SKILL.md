---
name: refresh-pr
description: Refreshes an existing in-progress pull request: update the branch with the latest base branch (usually develop), reconcile conflicts, improve/fix obvious issues, and rewrite the PR title/body based on the actual diff so it’s ready for review. Use when the user says “revisit PR”, “update PR with latest develop/main”, “finish this PR”, “make it reviewable”, or “I forgot what this PR does”.
---

# Refresh PR

Use this skill when a PR already exists and the user wants it updated, clarified, and put into a reviewable state.

## Workflow

1. **Load PR context**
   - Fetch PR metadata (title/body/base/head, commits, changed files).
   - Identify the base branch (default to `develop` unless the PR uses another).
   - If the PR body is missing/outdated, plan to reconstruct it from the diff.

2. **Get the branch locally**
   - Ensure remotes are fetched (`git fetch --all --prune`).
   - Check out the PR head branch.
   - Record ahead/behind vs base and diffstat vs base.

3. **Update with latest base**
   - Merge the latest remote base into the PR branch (prefer merge to preserve history unless user asked for rebase).
   - Resolve conflicts (keep changes scoped to the PR).
   - Push the updated branch if (and only if) the user asked to update the PR.

4. **Improve/fix what’s obviously broken**
   - Scan the changed files for correctness and CI hazards (broken YAML, missing tokens, brittle quoting/escaping, outdated action versions, etc.).
   - Make minimal, high-confidence improvements only.
   - Keep behavior changes scoped; do not introduce new dependencies or architecture.
   - Commit fixes in small logical commits if changes are non-trivial.

5. **Rewrite PR description (based on the real diff)**
   - Replace vague/WIP titles with a descriptive title.
   - PR title MUST include the ticket number (issue number) when one exists (typically derived from the branch name), e.g. `227 POC: clean architecture v2`.
   - Update the PR body to include:
     - **Summary** (1–3 bullets)
     - **Details** (what changed, why)
     - **Required secrets/config** (if applicable)
     - **Test plan** (how to validate safely)
     - **Notes / risks**

6. **Make it review-ready**
   - Ensure the working tree is clean (no unrelated changes).
   - Ensure branch is pushed and PR reflects the latest commits.
   - If the user wants it non-draft, attempt to mark “ready for review”.
     - If `gh pr edit` fails due to GraphQL/project-card issues, update title/body via `gh api -X PATCH /repos/{owner}/{repo}/pulls/{number}`.
     - If API doesn’t support converting draft → ready, tell the user to click “Ready for review” in the UI.

## Safety / Stop Conditions

- Stop before **adding dependencies**, new packages, new architecture, persistence changes, or UX changes.
- Stop before **committing/pushing** unless the user explicitly asked to update the PR (or asked you to make it reviewable, which implies pushing).
- Stop if there are **unrelated untracked/modified files** that might get swept into commits; isolate or clean them first.

## Final Response

Include:
- PR link + updated title.
- What changed since the last PR update (merge-from-base, new commits).
- Any improvements made.
- What to review (key files).
- Validation performed (or what’s still unvalidated).
