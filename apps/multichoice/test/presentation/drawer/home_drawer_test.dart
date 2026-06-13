import 'package:flutter_test/flutter_test.dart';
import 'package:multichoice/utils/user_accounts_feature.dart';

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

  test('drawer sign-in visibility follows user accounts flag', () {
    firebaseService.userAccountsEnabled = false;
    expect(isUserAccountsEnabled(), isFalse);

    firebaseService.userAccountsEnabled = true;
    expect(isUserAccountsEnabled(), isTrue);
  });
}
