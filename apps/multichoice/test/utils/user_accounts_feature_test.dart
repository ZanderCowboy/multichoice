import 'package:flutter_test/flutter_test.dart';
import 'package:multichoice/utils/user_accounts_feature.dart';

import '../helpers/user_accounts_test_helper.dart';

void main() {
  late UserAccountsTestHelper helper;

  setUp(() {
    helper = UserAccountsTestHelper()..register();
  });

  tearDown(() async {
    await helper.unregister();
  });

  test('isUserAccountsEnabled returns false when remote config is off', () {
    helper.userAccountsEnabled = false;
    expect(isUserAccountsEnabled(), isFalse);
  });

  test('isUserAccountsEnabled returns true when remote config is on', () {
    helper.userAccountsEnabled = true;
    expect(isUserAccountsEnabled(), isTrue);
  });
}
