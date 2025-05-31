import 'package:flutter_test/flutter_test.dart';

Future<void> permissionsDialog(
  WidgetTester tester, {
  bool? shouldDeny,
}) async {
  await tester.pumpAndSettle();
  expect(find.text('Permission Required'), findsOneWidget);
  expect(find.text('Deny'), findsOneWidget);
  expect(find.text('Open Settings'), findsOneWidget);

  if (shouldDeny ?? false) {
    await tester.tap(find.text('Deny'));
  } else {
    await tester.tap(find.text('Open Settings'));
  }
  await tester.pumpAndSettle();
  
  // Wait for any permission-related animations or state changes to complete
  await tester.pump(const Duration(milliseconds: 500));
}
