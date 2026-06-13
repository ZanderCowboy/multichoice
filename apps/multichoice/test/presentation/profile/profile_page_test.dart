import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multichoice/presentation/profile/profile_page.dart';

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

  testWidgets('does not show profile content when user accounts are disabled', (
    tester,
  ) async {
    firebaseService.userAccountsEnabled = false;

    await tester.pumpWidget(
      widgetWrapper(child: const ProfilePage()),
    );
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Email'), findsNothing);
  });
}
