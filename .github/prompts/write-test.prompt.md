---
name: write-test
description: Generate a test for a Flutter widget or feature following project conventions. Use when writing unit tests, widget tests, or integration tests for the multichoice app.
args:
- name: target
  description: The file, widget, or feature to write the test for (e.g., 'lib/presentation/shared/widgets/add_tab_card.dart')
- name: test_type
  description: The type of test to generate ('widget', 'unit', 'integration')
---

# Write Test Prompt

When generating tests for the multichoice Flutter app, follow these rules and conventions:

## General Rules
- Use `flutter_test` for widget and unit tests, `integration_test` for integration tests.
- Name test files as `<feature>_test.dart` and place them in `test/` mirroring the `lib/` structure.
- Use descriptive test names that describe the behavior (e.g., `'AddTabCard renders correctly and responds to tap'`).
- Focus on testing UI rendering, user interactions, and edge cases.
- Avoid heavy mocking; prefer testing with real widgets and data where possible.

## Widget Tests
- Use `testWidgets` function.
- Wrap widgets in the `widgetWrapper` helper from `test/helpers/widget_wrapper.dart` to provide `MaterialApp` and `Scaffold` context.
- Use `find` with semantic keys or text for widget location (e.g., `find.byKey(Key('AddTabSizedBox'))`).
- Test rendering: Check that widgets appear with `findsOneWidget`.
- Test interactions: Use `await tester.tap()` and `await tester.pumpAndSettle()` to simulate user actions.
- Assert properties: Use `expect` with matchers like `equals`, `isTrue`, `findsNothing`.

## Integration Tests
- Use `IntegrationTestWidgetsFlutterBinding.ensureInitialized()`.
- Place in `integration_test/` directory.
- Test full user journeys: Simulate real app usage (e.g., adding items, toggling settings).
- Use shared helpers from `integration_test/shared/` for common actions (e.g., `openDrawer`, `toggleSwitch`).
- Handle async operations with `pumpAndSettle` and appropriate timeouts.

## Unit Tests (if applicable)
- Use `test` function for pure logic testing.
- Test extensions and utilities in `test/app/`.

## Code Quality
- Follow the project's linting rules (very_good_analysis).
- Keep tests readable and maintainable.
- Include comments for complex test setups.

Generate the test code for the specified target, ensuring it compiles and runs correctly.