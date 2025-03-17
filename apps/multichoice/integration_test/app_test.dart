import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:multichoice/main.dart' as app;
import 'package:multichoice/presentation/shared/widgets/add_widgets/_base.dart';

import 'shared/export.dart';

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
