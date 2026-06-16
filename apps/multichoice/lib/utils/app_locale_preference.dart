import 'dart:async';

import 'package:core/core.dart';
import 'package:multichoice/i18n/strings.g.dart';

/// Applies the saved app locale preference, or device locale when unset.
Future<void> applySavedAppLocale() async {
  if (!coreSl.isRegistered<IAppStorageService>()) {
    await LocaleSettings.useDeviceLocale();
    return;
  }

  final savedLocale = await coreSl<IAppStorageService>().appLocale;
  switch (savedLocale) {
    case 'en':
      await LocaleSettings.setLocale(AppLocale.en);
    case 'nl':
      await LocaleSettings.setLocale(AppLocale.nl);
    case 'system':
    case null:
      await LocaleSettings.useDeviceLocale();
  }
}
