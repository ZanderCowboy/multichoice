import 'package:core/core.dart';

import 'fake_app_info_service.dart';
import 'fake_app_storage_service.dart';
import 'fake_firebase_service.dart';
import 'fake_login_service.dart';

class UserAccountsTestHelper {
  UserAccountsTestHelper({
    required this.firebaseService,
    this.loginService,
    FakeAppInfoService? appInfoService,
    FakeAppStorageService? appStorageService,
  })  : appInfoService = appInfoService ?? FakeAppInfoService(),
        appStorageService = appStorageService ?? FakeAppStorageService();

  final FakeFirebaseService firebaseService;
  final FakeLoginService? loginService;
  final FakeAppInfoService appInfoService;
  final FakeAppStorageService appStorageService;

  void register() {
    _registerSingleton<IFirebaseService>(firebaseService);

    final login = loginService;
    if (login != null) {
      _registerSingleton<ILoginService>(login);
    }

    _registerSingleton<IAppInfoService>(appInfoService);
    _registerSingleton<IAppStorageService>(appStorageService);
  }

  void unregister() {
    _unregister<IAppInfoService>();
    _unregister<IAppStorageService>();
    _unregister<IFirebaseService>();
    if (loginService != null) {
      _unregister<ILoginService>();
    }
  }

  void _registerSingleton<T extends Object>(T instance) {
    if (coreSl.isRegistered<T>()) {
      // ignore: discarded_futures
      coreSl.unregister<T>();
    }
    coreSl.registerSingleton<T>(instance);
  }

  void _unregister<T extends Object>() {
    if (coreSl.isRegistered<T>()) {
      // ignore: discarded_futures
      coreSl.unregister<T>();
    }
  }
}
