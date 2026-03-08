import 'package:core/src/get_it_injection.config.dart';
import 'package:core/src/services/implementations/analytics_service.dart';
import 'package:core/src/services/interfaces/i_analytics_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
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
  if (!coreSl.isRegistered<FirebaseAnalytics>()) {
    coreSl.registerLazySingleton<FirebaseAnalytics>(
      () => FirebaseAnalytics.instance,
    );
  }

  if (!coreSl.isRegistered<IAnalyticsService>()) {
    coreSl.registerLazySingleton<IAnalyticsService>(
      () => FirebaseAnalyticsService(),
    );
  }

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
