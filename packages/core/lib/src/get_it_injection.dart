import 'package:core/src/get_it_injection.config.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final coreSl = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<GetIt> configureCoreDependencies() async {
  // Manually register FirebaseRemoteConfig so that it can be injected into
  // FirebaseService via GetIt. This avoids modifying generated files while
  // ensuring the dependency is available during initialization.
  if (!coreSl.isRegistered<FirebaseRemoteConfig>()) {
    coreSl.registerLazySingleton<FirebaseRemoteConfig>(
      () => FirebaseRemoteConfig.instance,
    );
  }

  return coreSl.init();
}
