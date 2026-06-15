import 'package:core/core.dart';
import 'package:models/models.dart';

class FakeFirebaseService implements IFirebaseService {
  FakeFirebaseService({this.userAccountsEnabled = false});

  bool userAccountsEnabled;
  final Map<FirebaseConfigKeys, bool> _debugOverrides = {};

  @override
  bool isEnabled(FirebaseConfigKeys key) {
    if (_debugOverrides.containsKey(key)) {
      return _debugOverrides[key]!;
    }
    if (key == FirebaseConfigKeys.enableUserAccounts) {
      return userAccountsEnabled;
    }
    return false;
  }

  @override
  bool getRemoteBool(FirebaseConfigKeys key) {
    if (key == FirebaseConfigKeys.enableUserAccounts) {
      return userAccountsEnabled;
    }
    return false;
  }

  @override
  void setDebugOverride(FirebaseConfigKeys key, bool? value) {
    if (value == null) {
      _debugOverrides.remove(key);
      return;
    }
    _debugOverrides[key] = value;
  }

  @override
  bool hasDebugOverride(FirebaseConfigKeys key) {
    return _debugOverrides.containsKey(key);
  }

  @override
  void clearAllDebugOverrides() {
    _debugOverrides.clear();
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
