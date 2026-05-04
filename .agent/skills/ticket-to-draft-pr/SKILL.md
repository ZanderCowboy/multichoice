---
name: ticket-to-draft-pr
description: Implements a GitHub ticket end-to-end as either a fix or feature, updates the changelog, creates logical commits, pushes the branch, and opens a draft PR autonomously.
---

# Antigravity Skill: Ticket To Draft PR

Use this skill when the user wants a GitHub ticket handled from implementation through draft PR. As Antigravity, you can accomplish this autonomously using your toolset.

## Workflow

1. **Read the ticket**
   - Accept a GitHub issue number, issue URL, or clear ticket reference.
   - Use the `run_command` tool to run `gh issue view <number> --json title,body,labels` to fetch the ticket content if needed.
   - Determine whether the work is a fix or a feature from the ticket content and labels.
   - If the ticket type is unclear, ask the user whether to follow the fix or feature workflow before proceeding.

2. **Create or switch to a ticket branch**
   - Never do feature or fix development directly on `develop` (it is protected).
   - Use `run_command` to check the current branch (`git branch --show-current`) and status (`git status`).
   - If the current branch is `develop`, use `git checkout -b <branch-name>` to create and switch to a new branch before making any code changes.
   - Branch naming must include the workflow prefix (`feature/` or `fix/`) and the ticket number, for example:
     - `feature/55-add-new-feature`
     - `fix/256-this-is-a-bug`
   - If already on a non-`develop` branch, continue on the current branch unless it clearly does not match the ticket or the expected naming convention.

3. **Choose the implementation command**
   - Use `view_file` to read `.cursor/commands/feature.md` for new behavior/enhancements.
   - Use `view_file` to read `.cursor/commands/fix.md` for bugs, regressions, failing tests, etc.
   - Preserve all command stop conditions (e.g., ask the user before architecture, dependency, UX, public API, or persistence changes).

4. **Implement and validate**
   - Read the relevant `.cursor/rules` files before editing.
   - Implement the changes using `replace_file_content` or `multi_replace_file_content`. Keep changes scoped to the ticket.
   - Add or update focused tests when behavior changes.
   - Use `run_command` to run the narrowest useful validation first, then broaden for shared changes. Monitor the command with `command_status`.

5. **Update the changelog**
   - Read `.cursor/commands/changelog.md` via `view_file`.
   - Base the changelog on the actual diff (use `run_command` with `git diff` if needed).
   - Update the changelog file using your code modification tools.

6. **Create commits**
   - Read `.cursor/commands/commit.md`.
   - Use `run_command` to stage changes (`git add <files>`) and create small, logical commits (`git commit -m "..."`) grouped by functionality.
   - Exclude plan files, debug logs, secrets, credentials, and unrelated changes. Do not include unrelated user changes.

7. **Open a draft PR**
   - Read `.cursor/commands/create-pr.md`.
   - Use `run_command` to push the current branch (`git push -u origin HEAD`).
   - Use `run_command` to create the draft PR (`gh pr create --draft --base develop --title "<ticket-number> <Title>" --body "..."`).
   - The PR title MUST include the ticket number (issue number), e.g., `55 Add new feature`.

## Stop Conditions

- Stop and ask the user if the ticket lacks enough detail to identify the expected behavior.
- Stop if the current branch is `develop` and a ticket branch has not been created yet.
- Stop and ask before adding dependencies, packages, new architecture, public APIs, persistence changes, or UX changes.
- Stop and ask if implementation would alter existing behavior beyond the ticket scope.
- Stop before committing or creating a PR if validation is failing via your `run_command` checks.
- Stop if there are unrelated working tree changes that would be included in commits.

## Final Response

Once the draft PR is created, provide a final response to the user including:
- Ticket number and title.
- Whether the workflow followed fix or feature.
- Summary of implementation and files changed.
- Validation performed.
- Commit summary.
- Draft PR URL.
- Any skipped validation, remaining risks, or follow-up decisions needed from the user.
