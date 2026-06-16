# Test Command

Create or fix tests for the specified file or behavior.

See `.cursor/rules/testing-rules.mdc` and `.cursor/templates/bloc-test-template.dart` / `repository-test-template.dart`.

- Mirror source path under `test/`; use `mocks.dart` + `mocks.mocks.dart` in core.
- New mocks: add `MockSpec` to `mocks.dart`, run `make db` or `melos run rebuild:core`.
- Run `melos test:core` or `melos test:multichoice` for the touched package.
- Prefer DI over static singletons; do not change public APIs unless required.

Ask only when required behavior is genuinely ambiguous.
