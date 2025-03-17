import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multichoice/presentation/shared/widgets/add_widgets/_base.dart';

Future<void> permissionsDialog(
  WidgetTester tester, {
  bool? shouldDeny,
}) async {
  expect(find.text('Permission Required'), findsOneWidget);
  expect(find.text('Deny'), findsOneWidget);
  expect(find.text('Open Settings'), findsOneWidget);

  if (shouldDeny ?? false) {
    await tester.tap(find.text('Deny'));
  } else {
    // add open settings
  }
  await tester.pumpAndSettle();

  expect(find.byIcon(Icons.add_outlined), findsOneWidget);
  expect(find.byType(AddTabCard), findsOneWidget);
}
