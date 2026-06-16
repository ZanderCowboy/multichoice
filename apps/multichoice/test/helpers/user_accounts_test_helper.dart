import 'package:core/core.dart';
import 'package:mockito/mockito.dart';
import 'package:models/models.dart';

import '../../../../packages/core/test/mocks.mocks.dart';

class UserAccountsTestHelper {
  UserAccountsTestHelper({
    MockFirebaseService? firebaseService,
    this.loginService,
    MockAppInfoService? appInfoService,
    MockAppStorageService? appStorageService,
    MockRegistrationRepository? registrationRepository,
  }) : firebaseService = firebaseService ?? MockFirebaseService(),
       appInfoService = appInfoService ?? MockAppInfoService(),
       appStorageService = appStorageService ?? MockAppStorageService(),
       registrationRepository =
           registrationRepository ?? MockRegistrationRepository();

  factory UserAccountsTestHelper.withLoginService() {
    return UserAccountsTestHelper(loginService: MockLoginService());
  }

  final MockFirebaseService firebaseService;
  final MockLoginService? loginService;
  final MockAppInfoService appInfoService;
  final MockAppStorageService appStorageService;
  final MockRegistrationRepository registrationRepository;

  bool userAccountsEnabled = false;
  bool loggedIn = false;
  final _debugOverrides = <FirebaseConfigKeys, bool>{};

  void register() {
    _stubFirebaseService();
    _stubAppInfoService();
    _stubLoginService();
    _stubRegistrationRepository();

    _registerSingleton<IFirebaseService>(firebaseService);

    final login = loginService;
    if (login != null) {
      _registerSingleton<ILoginService>(login);
    }

    _registerSingleton<IAppInfoService>(appInfoService);
    _registerSingleton<IAppStorageService>(appStorageService);
  }

  void registerProfileBloc() {
    final login = loginService;
    if (login == null) {
      throw StateError(
        'registerProfileBloc requires a login service; use withLoginService().',
      );
    }

    _registerSingleton<ProfileBloc>(
      ProfileBloc(login, appStorageService, registrationRepository),
    );
  }

  Future<void> unregister() async {
    if (coreSl.isRegistered<ProfileBloc>()) {
      await coreSl<ProfileBloc>().close();
      _unregister<ProfileBloc>();
    }
    _unregister<IAppInfoService>();
    _unregister<IAppStorageService>();
    _unregister<IFirebaseService>();
    if (loginService != null) {
      _unregister<ILoginService>();
    }
  }

  void _stubFirebaseService() {
    when(firebaseService.isEnabled(any)).thenAnswer((invocation) {
      final key = invocation.positionalArguments[0] as FirebaseConfigKeys;
      if (_debugOverrides.containsKey(key)) {
        return _debugOverrides[key]!;
      }
      if (key == FirebaseConfigKeys.enableUserAccounts) {
        return userAccountsEnabled;
      }
      return false;
    });
    when(firebaseService.getRemoteBool(any)).thenAnswer((invocation) {
      final key = invocation.positionalArguments[0] as FirebaseConfigKeys;
      if (key == FirebaseConfigKeys.enableUserAccounts) {
        return userAccountsEnabled;
      }
      return false;
    });
    when(firebaseService.hasDebugOverride(any)).thenAnswer((invocation) {
      final key = invocation.positionalArguments[0] as FirebaseConfigKeys;
      return _debugOverrides.containsKey(key);
    });
    when(firebaseService.setDebugOverride(any, any)).thenAnswer((invocation) {
      final key = invocation.positionalArguments[0] as FirebaseConfigKeys;
      final value = invocation.positionalArguments[1] as bool?;
      if (value == null) {
        _debugOverrides.remove(key);
      } else {
        _debugOverrides[key] = value;
      }
    });
    when(firebaseService.clearAllDebugOverrides()).thenAnswer((_) {
      _debugOverrides.clear();
    });
    when(firebaseService.initialize()).thenAnswer((_) async {});
    when(firebaseService.fetchAndActivate()).thenAnswer((_) async {});
    when(firebaseService.forceFetchAndActivate()).thenAnswer((_) async {});
    when(
      firebaseService.getConfig<Object?>(any, any),
    ).thenAnswer((_) async => null);
    when(firebaseService.getString(any)).thenAnswer((_) async => null);
  }

  void _stubAppInfoService() {
    when(appInfoService.getAppVersion()).thenAnswer((_) async => '1.0.0+45');
    when(
      appInfoService.getDisplayAppVersion(),
    ).thenAnswer((_) async => '1.0.0');
    when(
      appInfoService.isUpdateAvailable(any),
    ).thenAnswer((_) async => false);
  }

  void _stubLoginService() {
    final login = loginService;
    if (login == null) {
      return;
    }

    when(login.isUserLoggedIn()).thenAnswer((_) async => loggedIn);
    when(login.getAccessToken()).thenAnswer((_) async => 'token');
    when(login.getProfileEmail()).thenAnswer((_) async => 'user@example.com');
    when(login.getProfileUsername()).thenAnswer((_) async => 'alice');
    when(login.deleteLoginInfo()).thenAnswer((_) async {
      loggedIn = false;
    });
    when(login.storeLoginInfo(any)).thenAnswer((_) async {
      loggedIn = true;
    });
    when(
      login.storeUserProfile(
        email: anyNamed('email'),
        username: anyNamed('username'),
      ),
    ).thenAnswer((_) async {});
    when(login.storeUsernameEmailMapping(any, any)).thenAnswer((_) async {});
    when(login.resolveEmailForLogin(any)).thenAnswer((invocation) async {
      final identifier = invocation.positionalArguments[0] as String;
      if (identifier.contains('@')) {
        return identifier;
      }
      return null;
    });
    when(login.markUsernameConfirmed(any)).thenAnswer((_) async {});
    when(login.isUsernameConfirmed(any)).thenAnswer((_) async => false);
  }

  void _stubRegistrationRepository() {
    when(
      registrationRepository.hasPasswordProvider(),
    ).thenAnswer((_) async => true);
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
