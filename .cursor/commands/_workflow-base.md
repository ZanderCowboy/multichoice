# Shared Workflow Base

Include these steps in feature, fix, and similar implementation commands.

## Before editing

1. Read relevant `.cursor/rules/` files (not all — pick by area: `ui-rules`, `api-rules`, `testing-rules`, `code-organization`).
2. Read `.cursor/references/` when product or UX context is needed.
3. Search for existing implementations; match nearby architecture, naming, and folder layout.

## Implementation

- Keep changes scoped to the ticket or user request.
- Ask before new dependencies, packages, service boundaries, state management, persistence, or UX pattern changes.
- Preserve shipped behavior unless the ticket requires a change and the user confirms risk.
- Mocks/codegen: check `mocks.dart` first; run `make db` via Melos — never hand-edit generated files.

## Validation

1. Narrowest relevant test (`melos test:core` / `melos test:multichoice`).
2. Scoped analyze: `melos exec --scope=<touched-package> -- flutter analyze`.
3. `melos analyze` / `melos test:all` only for cross-package changes.
4. Fix introduced lints and test failures; state skipped validation and risk if blocked.

## Completion

- Summarize what changed and why; list validation run.
- Do not commit or push unless the user explicitly asks.
