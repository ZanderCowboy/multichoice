import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/main.dart' as app;
import 'package:multichoice/presentation/shared/widgets/add_widgets/_base.dart';

/// This test will run a journey where the user
///
/// - opens the app with no existing data,
/// - adds new data,
/// - toggles theme and layout,
/// - exports data,
/// - clears all data,
/// - and exists the app.
///
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final keys = WidgetKeys.instance;

  testWidgets('Test counter increment', (WidgetTester tester) async {
    app.main();
    // Wait for the app to settle
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Verify a Permission Required dialog appears
    expect(find.text('Permission Required'), findsOneWidget);
    expect(find.text('Deny'), findsOneWidget);
    expect(find.text('Open Settings'), findsOneWidget);
    await tester.tap(find.text('Deny'));
    await tester.pumpAndSettle();

    // On Home Screen - Verify Add Tab Card
    expect(find.byIcon(Icons.add_outlined), findsOneWidget);
    expect(find.byType(AddTabCard), findsOneWidget);

    // Open Settings Drawer - Test Layout Switch
    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Horizontal/Vertical Layout'), findsOneWidget);
    expect(find.byKey(keys.layoutSwitch), findsOneWidget);
    await tester.tap(find.byKey(keys.layoutSwitch));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.close_outlined), findsOneWidget);
    await tester.tap(find.byIcon(Icons.close_outlined));
    await tester.pumpAndSettle();

    // On Home Screen - Add New Tab
    expect(find.byIcon(Icons.add_outlined), findsOneWidget);
    expect(find.byType(AddTabCard), findsOneWidget);
    await tester.tap(find.byType(AddTabCard));
    await tester.pumpAndSettle();

    // Add New Tab Dialog
    expect(find.text('Add New Tab'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Add'), findsOneWidget);

    // Enter Tab Data
    expect(find.byType(TextFormField), findsExactly(2));
    await tester.enterText(find.byType(TextFormField).first, 'Tab 1');
    await tester.enterText(find.byType(TextFormField).last, 'Tab 2');
    await tester.pumpAndSettle();
    expect(find.text('Tab 1'), findsOneWidget);
    expect(find.text('Tab 2'), findsOneWidget);
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    expect(find.text('Tab 1'), findsOneWidget);

    // Open Settings Drawer - Test Light/Dark Mode
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Light / Dark Mode'), findsOneWidget);
    expect(find.byKey(keys.lightDarkModeSwitch), findsOneWidget);
    await tester.tap(find.byKey(keys.lightDarkModeSwitch));
    await tester.pumpAndSettle();
    expect(find.text('Tab 1'), findsOneWidget);
    expect(find.byType(AddTabCard), findsOneWidget);
    final BuildContext context = tester.element(find.byType(AddTabCard));
    final theme = Theme.of(context);
    expect(theme.brightness, Brightness.dark);

    // On Home Screen
    await tester.tap(find.byIcon(Icons.search_outlined));
    await tester.pumpAndSettle();
    expect(find.textContaining('not been implemented'), findsOneWidget);
  });
}
import 'shared/export.dart';


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Test User Journey', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 5));

    await permissionsDialog(tester, shouldDeny: true);

    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    var isVertical = true;
    // Will still possibly be used.
    // ignore: unused_local_variable
    final layoutSwitch = Switch(
      value: isVertical,
      onChanged: (bool value) {
        isVertical = value;
      },
    );
    expect(find.text('Horizontal/Vertical Layout'), findsOneWidget);
    expect(find.byKey(const Key('layoutSwitch')), findsOneWidget);
    await tester.tap(find.byKey(const Key('layoutSwitch')));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.close_outlined), findsOneWidget);
    await tester.tap(find.byIcon(Icons.close_outlined));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.add_outlined), findsOneWidget);
    expect(find.byType(AddTabCard), findsOneWidget);

    await tester.tap(find.byType(AddTabCard));
    await tester.pumpAndSettle();

    await TabsActions.pressAndOpenAddTab(tester);
    await TabsActions.addTabDialog(tester, 'Tab 1', 'Tab 2');

    expect(find.text('Tab 1'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.search_outlined));
    await tester.pumpAndSettle();
    expect(find.textContaining('not been implemented'), findsOneWidget);
  });
}
