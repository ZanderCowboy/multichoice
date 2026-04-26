# Fix Command

Fix an identified issue, regression, analyzer problem, failing test, CI failure, or bug report.

The goal of this command is to resolve the specific issue with the smallest correct code change possible while preserving the app's architecture, layout, and existing behavior.

## Inputs

The user may provide one of:

- A GitHub issue number, for example `#12` or `12`
- A GitHub issue URL
- A failing command, analyzer output, test failure, stack trace, screenshot, or bug description
- No specific input, when they want current analyzer or test issues investigated

If the input is missing, first check for current analyzer issues. If there are no visible issues, tell the user and ask what bug, failure, or GitHub issue should be fixed.

## Process

1. **Read the issue or failure**
   - If the user provides an issue number or GitHub URL, fetch the ticket details with GitHub CLI when available:
     - `gh issue view <issue-number> --json number,title,body,labels,url,state`
     - For a full URL, use `gh issue view <url> --json number,title,body,labels,url,state`
   - If the user provides logs, stack traces, screenshots, failing tests, or analyzer output, treat that evidence as the source of truth.
   - If no issue details are available, inspect current analyzer/linter feedback and relevant test failures.
   - Do not guess the bug. If the failure cannot be identified, ask for the missing reproduction details.

2. **Confirm the work is a fix**
   - Continue only if the task is to correct broken, incorrect, failing, or unintended behavior.
   - If the request is actually a new feature, enhancement, broad refactor, or test-only improvement, tell the user and suggest the more appropriate command.

3. **Inspect the current codebase first**
   - Read the relevant `.cursor/rules` files before implementation, especially:
     - `project-structure.mdc`
     - `code-organization.mdc`
     - `development-workflow.mdc`
     - `ui-rules.mdc` when UI is involved
     - `testing-rules.mdc` when tests are involved
   - Search for the existing implementation, nearby tests, similar bug fixes, constants, state handling, services, repositories, models, routes, and UI patterns.
   - Prefer existing architecture, package boundaries, dependency injection, naming, layout, and folder structure.

4. **Reproduce or prove the issue**
   - Run the narrowest command that demonstrates the problem when practical.
   - For analyzer issues, capture the specific diagnostic and affected file.
   - For test failures, run the smallest relevant test target first.
   - For runtime bugs that cannot be reproduced locally, reason from the provided evidence and state the assumption before editing.

5. **Identify the root cause**
   - Trace the failing path before changing code.
   - Confirm the smallest code location responsible for the issue.
   - Do not apply speculative fixes.
   - Do not change adjacent code just because it looks suspicious.

6. **Plan briefly before editing**
   - Summarize the issue and root cause.
   - Identify the minimal file or files that need changes.
   - Identify the validation command that should fail before the fix and pass after the fix.
   - If the fix requires a new dependency, new package, new architecture, new public API, new persistence behavior, or a UX change, stop and ask the user for confirmation before editing.

7. **Implement the minimal fix**
   - Make only the code changes required to fix the identified issue.
   - Avoid "extra" changes that might also help.
   - Do not refactor unrelated code.
   - Do not clean up surrounding code unless it is directly required for the fix.
   - Do not broaden behavior beyond the failing case.
   - Preserve existing architecture, package boundaries, look and feel, constants, and local code style.
   - For services, keep the existing `interfaces/` and `implementations/` pattern.
   - For UI fixes, match nearby layouts, typography, spacing, interaction patterns, and empty/error/loading states.
   - Use existing constants before introducing new literals.

8. **Tests and generated code**
   - Add or update a focused regression test when the fix affects logic, behavior, or a user-facing flow.
   - Keep tests minimal and targeted to the bug.
   - Mirror existing test structure and naming.
   - When mocks are needed, first look for `mocks.dart` and use existing generated mocks.
   - If new mocks or generated files are required, update the source definition and run build_runner through Melos.
   - Do not hand-edit generated files.

9. **Validation**
   - Re-run the command, test, analyzer check, or workflow that exposed the issue.
   - Run the narrowest useful validation first, then broaden only if the change touches shared behavior:
     - relevant package test
     - relevant app test
     - `melos analyze`
     - `melos test:all` for broad or shared fixes
   - Run formatting if Dart files were edited.
   - Fix introduced lints, analyzer issues, and test failures.
   - If validation cannot be run, explain why and state the remaining risk.

10. **Completion response**
   - Summarize the issue fixed and the root cause.
   - Mention the GitHub issue number and title when applicable.
   - If a PR is created as part of the workflow, ensure the PR title includes the ticket/issue number.
   - List validation performed.
   - Call out any behavior changes, skipped validation, remaining risk, or user decisions still needed.

## Minimal Change Rules

- The code changes can only fix the issue or they cannot be made.
- No speculative fixes.
- No "while I am here" cleanup.
- No broad refactors.
- No unrelated formatting churn.
- No behavior changes outside the failing case unless the issue explicitly requires it.
- If the correct fix cannot be made minimally, stop and explain why.

## Decision Rules

- Ask the user before adding new dependencies.
- Ask the user before adding a new package, service boundary, state management approach, route structure, or persistence mechanism.
- Ask the user before changing existing UX patterns or visual language.
- Ask the user before changing stable public APIs, persisted data formats, or behavior outside the bug scope.
- If multiple fixes are possible and the choice materially affects behavior or architecture, present the options and ask the user to choose.
- If the evidence is insufficient to identify the failing behavior, ask the smallest useful clarifying question.

## Important Rules

- Strictly fit the fix into the current architecture and layout.
- Follow all repository rules and local code patterns.
- Preserve the app's look and feel.
- Keep edits focused on the identified issue.
- Do not create unrelated refactors.
- Do not commit or push changes unless the user explicitly asks.
- If there are no analyzer issues, failing tests, CI failures, or provided bug details, indicate that there is nothing specific to fix.
