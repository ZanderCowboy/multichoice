import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multichoice/presentation/registration/login_modal.dart';

import '../../helpers/export.dart';
import '../../helpers/fake_firebase_service.dart';
import '../../helpers/user_accounts_test_helper.dart';

void main() {
  late UserAccountsTestHelper helper;
  late FakeFirebaseService firebaseService;

  setUp(() {
    firebaseService = FakeFirebaseService();
    helper = UserAccountsTestHelper(firebaseService: firebaseService)
      ..register();
  });

  tearDown(() {
    helper.unregister();
  });

  testWidgets('does not open login modal when user accounts are disabled', (
    tester,
  ) async {
    firebaseService.userAccountsEnabled = false;

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
