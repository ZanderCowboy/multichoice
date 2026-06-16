import 'dart:async';

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
              onPressed: () {
                unawaited(
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const ProfilePage(),
                    ),
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
