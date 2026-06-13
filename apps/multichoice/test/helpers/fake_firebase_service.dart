import 'package:core/core.dart';
import 'package:models/models.dart';

class FakeFirebaseService implements IFirebaseService {
  FakeFirebaseService({this.userAccountsEnabled = false});

  bool userAccountsEnabled;

  @override
  bool isEnabled(FirebaseConfigKeys key) {
    if (key == FirebaseConfigKeys.enableUserAccounts) {
      return userAccountsEnabled;
    }
    return false;
  }

  @override
  Future<void> fetchAndActivate() async {}

  @override
  Future<void> forceFetchAndActivate() async {}

  @override
  Future<T?> getConfig<T>(
    FirebaseConfigKeys key,
    T Function(Map<String, dynamic>) fromJson,
  ) async =>
      null;

  @override
  Future<void> initialize() async {}

  @override
  Future<String?> getString(FirebaseConfigKeys key) async => null;
}
