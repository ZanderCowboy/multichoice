---
name: ticket-to-draft-pr
description: Implements a GitHub ticket end-to-end as either a fix or feature, then updates the changelog, creates logical commits, pushes the branch, and opens a draft PR. Use when the user provides a GitHub issue number or URL and asks to ship, implement, fix, feature, or take it through draft PR.
---

# Ticket To Draft PR

Use this skill when the user wants a GitHub ticket handled from implementation through draft PR.

## Workflow

1. **Read the ticket**
   - Accept a GitHub issue number, issue URL, or clear ticket reference.
   - Fetch the issue with GitHub CLI when available.
   - Determine whether the work is a fix or a feature from the ticket content and labels.
   - If the ticket type is unclear, ask whether to follow the fix or feature workflow.

2. **Choose the implementation command**
   - For new behavior or enhancements, follow `.cursor/commands/feature.md`.
   - For bugs, regressions, failing tests, analyzer issues, or CI failures, follow `.cursor/commands/fix.md`.
   - Preserve all command stop conditions, especially asking before architecture, dependency, UX, public API, or persistence changes.

3. **Implement and validate**
   - Read the relevant `.cursor/rules` files before editing.
   - Implement within the current architecture and app look and feel.
   - Keep fix changes minimal and feature changes scoped to the ticket.
   - Add or update focused tests when behavior changes.
   - Run the narrowest useful validation first, then broaden for shared changes.

4. **Update the changelog**
   - Follow `.cursor/commands/changelog.md`.
   - Base the changelog on the actual diff.
   - Keep it concise and ticket-focused.

5. **Create commits**
   - Follow `.cursor/commands/commit.md`.
   - Create small, logical commits grouped by functionality.
   - Exclude plan files, debug logs, secrets, credentials, and unrelated changes.
   - Do not include unrelated user changes.

6. **Open a draft PR**
   - Follow `.cursor/commands/create-pr.md`.
   - Push the current branch.
   - Create the PR as a draft.
   - Use `develop` as the default base unless the user specifies another base.
   - Include the ticket number, summary, testing, breaking changes, and screenshot/video table.

## Stop Conditions

- Stop and ask if the ticket lacks enough detail to identify the expected behavior.
- Stop and ask before adding dependencies, packages, new architecture, public APIs, persistence changes, or UX changes.
- Stop and ask if implementation would alter existing behavior beyond the ticket scope.
- Stop before committing or creating a PR if validation is failing and the failure is not clearly unrelated.
- Stop if there are unrelated working tree changes that would be included in commits.

## Final Response

Include:

- Ticket number and title.
- Whether the workflow followed fix or feature.
- Summary of implementation.
- Validation performed.
- Commit summary.
- Draft PR URL.
- Any skipped validation, remaining risks, or follow-up decisions.
