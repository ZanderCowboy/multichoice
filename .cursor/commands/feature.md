# Feature Command

Implement a new feature or app functionality from a GitHub issue link or issue number.

The goal of this command is to reduce user-dependent input while still protecting the app's architecture, user experience, and existing behavior.

## Inputs

The user should provide one of:

- A GitHub issue number, for example `#12` or `12`
- A GitHub issue URL
- A GitHub pull request URL only when it clearly describes the feature request

If the input is missing, ask the user for the GitHub issue link or issue number before starting.

## Process

1. **Read the ticket**
   - If the user provides an issue number, use the current repository remote to resolve it.
   - If the user provides a GitHub URL, extract the repository and issue number from the URL.
   - Use GitHub CLI when available, for example:
     - `gh issue view <issue-number> --json number,title,body,labels,url,state`
     - For a full URL, use `gh issue view <url> --json number,title,body,labels,url,state`
   - If the issue cannot be fetched, ask the user for the missing details instead of guessing.
   - Treat the GitHub issue as the source of truth for feature requirements.

2. **Confirm the work is a feature**
   - Continue only if the ticket describes new user-facing behavior, new internal functionality, or an enhancement to existing functionality.
   - If the ticket is actually a bug fix, test-only task, refactor, or release task, tell the user and suggest the more appropriate command.

3. **Inspect the current codebase first**
   - Read the relevant `.cursor/rules` files before implementation, especially:
     - `project-structure.mdc`
     - `code-organization.mdc`
     - `development-workflow.mdc`
     - `ui-rules.mdc` when UI is involved
     - `testing-rules.mdc` when tests are involved
   - Search for existing implementations, widgets, services, repositories, models, constants, routes, state management, tests, and patterns that already solve similar problems.
   - Prefer existing architecture, package boundaries, dependency injection, naming, layout, and folder structure.

4. **Plan briefly before editing**
   - Summarize the feature requirements from the issue.
   - Identify the likely files or modules that need changes.
   - Identify required tests and validation commands.
   - If the feature requires a new architectural concept, new dependency, new package, new design pattern, new navigation structure, new public API, or a change to an existing contract, stop and ask the user for confirmation before editing.

5. **Protect existing behavior**
   - Before changing behavior, determine whether the feature alters or breaks existing app functionality.
   - If existing behavior will change, flag it clearly and ask the user for input unless the GitHub issue explicitly requires that change.
   - Do not remove backward compatibility for shipped behavior, persisted data, stable public APIs, or user-facing flows unless the ticket explicitly calls for it and the user confirms the risk.

6. **Implement within the existing architecture**
   - Keep changes scoped to the feature.
   - Follow the existing layer boundaries:
     - UI and pages in the app presentation layer
     - Reusable UI in `packages/ui_kit`
     - Business logic and services in `packages/core`
     - Shared models in `packages/models`
     - Theme and styling in `packages/theme`
   - For services, use the existing `interfaces/` and `implementations/` pattern.
   - For new pages, keep `Scaffold` and `AppBar` in the parent class and the body in a private child class.
   - For modular widgets, use private files and `part`/`part of` where that is the existing local pattern. Keep `part` sections alphabetical.
   - Use existing constants before introducing new literals:
     - spacing constants
     - border constants
     - colors and theme values
     - widget keys
   - Respect the current look and feel of the app. Match nearby layouts, typography, spacing, interaction patterns, and empty/error/loading states.

7. **Tests and generated code**
   - Add or update tests for new behavior.
   - Mirror existing test structure and naming.
   - When mocks are needed, first look for `mocks.dart` and use existing generated mocks.
   - If new mocks or generated files are required, update the source definition and run build_runner through Melos.
   - Do not hand-edit generated files.

8. **Validation**
   - Run the narrowest useful validation first, then broaden if needed:
     - relevant package tests
     - relevant app tests
     - scoped analyze for the touched package/app:
       - `melos exec --scope=multichoice -- flutter analyze` (app-only changes)
       - `melos exec --scope=core -- flutter analyze` (core-only changes)
       - `melos exec --scope=ui_kit -- flutter analyze` (ui kit only)
       - `melos exec --scope=models -- flutter analyze` (models only)
       - `melos exec --scope=theme -- flutter analyze` (theme only)
     - `melos analyze` only when changes span multiple packages
     - `melos test:all` for broad or shared changes
   - Run formatting if Dart files were edited.
   - Fix introduced lints, analyzer issues, and test failures.
   - If validation cannot be run, explain why and state the remaining risk.

9. **Completion response**
   - Summarize what was implemented and why.
   - Mention the GitHub issue number and title.
   - If a PR is created as part of the workflow, ensure the PR title includes the ticket/issue number.
   - List validation performed.
   - Call out any behavior changes, follow-up work, skipped validation, or user decisions still needed.

## Decision Rules

- Ask the user before adding new dependencies.
- Ask the user before adding a new package, service boundary, state management approach, route structure, or persistence mechanism.
- Ask the user before changing existing UX patterns or visual language.
- Ask the user before changing stable public APIs, persisted data formats, or behavior outside the ticket scope.
- If the issue is detailed enough and the solution fits existing patterns, proceed without extra clarification.
- If multiple implementation paths are valid and materially affect architecture or UX, present the options and ask the user to choose.

## Important Rules

- Strictly fit the feature into the current architecture and layout.
- Follow all repository rules and local code patterns.
- Preserve the app's look and feel.
- Keep edits focused on the GitHub ticket.
- Do not create unrelated refactors.
- Do not commit or push changes unless the user explicitly asks.
- Do not guess missing product behavior. Ask the smallest useful clarifying question.
