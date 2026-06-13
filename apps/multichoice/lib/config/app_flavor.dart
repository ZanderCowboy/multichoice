import 'package:flutter/foundation.dart';

abstract final class AppFlavor {
  static const flavor = String.fromEnvironment(
    'APP_FLAVOR',
    defaultValue: 'prod',
  );

  static bool get isDev => flavor == 'dev';
  static bool get isProd => !isDev;

  /// DEV builds (any mode): debug page + dev banner.
  static bool get allowsDebugPage => isDev;

  /// DEV any mode = dev banner; PROD debug/profile = prod banner; PROD release = none.
  static bool get showsEnvironmentBanner => isDev || (isProd && !kReleaseMode);
}
