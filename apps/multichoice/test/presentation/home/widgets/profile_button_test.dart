import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/view/auth/auth_notifier.dart';
import 'package:multichoice/app/view/debug/remote_config_debug_notifier.dart';
import 'package:multichoice/presentation/home/widgets/profile_button.dart';
import 'package:provider/provider.dart';

import '../../../helpers/export.dart';
import '../../../helpers/fake_firebase_service.dart';
import '../../../helpers/fake_login_service.dart';
import '../../../helpers/user_accounts_test_helper.dart';

void main() {
  late UserAccountsTestHelper helper;
  late FakeFirebaseService firebaseService;
  late FakeLoginService loginService;
  late AuthNotifier authNotifier;
  late RemoteConfigDebugNotifier remoteConfigDebugNotifier;

  setUp(() {
    firebaseService = FakeFirebaseService();
    loginService = FakeLoginService();
    helper = UserAccountsTestHelper(
      firebaseService: firebaseService,
      loginService: loginService,
    )..register();
    authNotifier = AuthNotifier();
    remoteConfigDebugNotifier = RemoteConfigDebugNotifier();
  });

  tearDown(() {
    helper.unregister();
    authNotifier.dispose();
    remoteConfigDebugNotifier.dispose();
  });

  Widget buildSubject() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthNotifier>.value(value: authNotifier),
        ChangeNotifierProvider<RemoteConfigDebugNotifier>.value(
          value: remoteConfigDebugNotifier,
        ),
      ],
      child: widgetWrapper(child: const ProfileButton()),
    );
  }

  testWidgets('hides profile and sign in when user accounts are disabled', (
    tester,
  ) async {
    firebaseService.userAccountsEnabled = false;
    loginService.loggedIn = false;

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.person_outline), findsNothing);
    expect(find.text('Sign In'), findsNothing);
  });

  testWidgets('shows sign in when flag is on and user is logged out', (
    tester,
  ) async {
    firebaseService.userAccountsEnabled = true;
    loginService.loggedIn = false;

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.text('Sign In'), findsOneWidget);
  });

  testWidgets('shows profile icon when flag is on and user is logged in', (
    tester,
  ) async {
    firebaseService.userAccountsEnabled = true;
    loginService.loggedIn = true;

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.person_outline), findsOneWidget);
    expect(find.text('Sign In'), findsNothing);
  });

  testWidgets('hides sign in when user accounts flag is overridden off', (
    tester,
  ) async {
    firebaseService.userAccountsEnabled = true;
    loginService.loggedIn = false;

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.text('Sign In'), findsOneWidget);

    remoteConfigDebugNotifier.setOverride(
      key: FirebaseConfigKeys.enableUserAccounts,
      value: false,
    );
    await tester.pump();

    expect(find.text('Sign In'), findsNothing);
  });
}
