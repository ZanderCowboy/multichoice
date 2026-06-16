import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multichoice/presentation/registration/login_modal.dart';

import '../../helpers/export.dart';

void main() {
  late UserAccountsTestHelper helper;

  setUp(() {
    helper = UserAccountsTestHelper()..register();
  });

  tearDown(() async {
    await helper.unregister();
  });

  testWidgets('does not open login modal when user accounts are disabled', (
    tester,
  ) async {
    helper.userAccountsEnabled = false;

    await tester.pumpWidget(
      widgetWrapper(
        child: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () => showLoginModal(context),
              child: const Text('Open login'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open login'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
  });
}
