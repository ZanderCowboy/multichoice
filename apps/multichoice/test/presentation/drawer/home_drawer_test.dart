import 'package:flutter_test/flutter_test.dart';
import 'package:multichoice/utils/user_accounts_feature.dart';

import '../../helpers/user_accounts_test_helper.dart';

void main() {
  late UserAccountsTestHelper helper;

  setUp(() {
    helper = UserAccountsTestHelper()..register();
  });

  tearDown(() async {
    await helper.unregister();
  });

  test('drawer sign-in visibility follows user accounts flag', () {
    helper.userAccountsEnabled = false;
    expect(isUserAccountsEnabled(), isFalse);

    helper.userAccountsEnabled = true;
    expect(isUserAccountsEnabled(), isTrue);
  });
}
