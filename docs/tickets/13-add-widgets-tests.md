# [Setting and Adding Widget Tests](https://github.com/ZanderCowboy/multichoice/issues/13)

Setting up and adding widget tests for `multichoice`

## How to Setup Widget Tests

In the `apps/multichoice` directory, add a folder `test` with a structure that represents the presentation structure of the widgets.
Start each test with the normal `main`. Instead of calling the usual `test` method for unit tests, call the `testWidgets` method and pass in a `WidgetTester`.

From there, add a call to `pumpWidget` that will render the UI of the given widget. Be sure to pass in a `MaterialApp` and the usual scaffold for the widget to render correctly.

After the test is set up, start testing the widget by using the `tap` method followed by a `pumpAndSettle` to wait for the UI to render. One can then verify that the widget render correctly by using `expect` to check for specific elements.

```dart
void main() {
    testWidgets('description', (WidgetTester tester) async {
        await tester.pumpWidget(
            MaterialApp(
                // Scaffold and the dummy set up to use the widget
            ),
        );

        await tester.tap(find.text('Some string found on the rendered page'));
        await tester.pumpAndSettle(); // Wait for the UI to render

        expect(find.byType(SomeTypeOrWidget), findsOneWidget);

        // etc.
    });
}
```

## What was done

- Update code to include `Key`'s for `WidgetTest`
- Create a `widgetWrapper` method
- Create `WidgetKeys` class containing `Key`'s
- Create `WidgetKeysExtension` to return instance of `WidgetKeys`. It can be used as follows:
```dart
key: context.keys.keyName
```
- Update `melos` with `coverage:multichoice` to run widget tests on Windows and get reporting
- Add widget tests for the following:
  - ExtensionsGettersTest
  - HomeDrawerTest
  - EntryTest
  - TabTest
  - DeleteModalTest
