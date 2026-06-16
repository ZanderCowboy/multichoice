import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multichoice/presentation/profile/profile_page.dart';

import '../../helpers/export.dart';

void main() {
  late UserAccountsTestHelper helper;

  setUp(() {
    helper = UserAccountsTestHelper.withLoginService()
      ..register()
      ..registerProfileBloc();
  });

  tearDown(() async {
    await helper.unregister();
  });

  testWidgets('pops profile route when user accounts are disabled', (
    tester,
  ) async {
    helper.userAccountsEnabled = false;

    await tester.pumpWidget(
      widgetWrapper(
        child: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () async {
                await Navigator.of(context).push<void>(
                  PageRouteBuilder<void>(
                    pageBuilder: (_, _, _) => const ProfilePage(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              },
              child: const Text('Open profile'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open profile'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Email'), findsNothing);
    expect(find.text('Open profile'), findsOneWidget);
  });
}
