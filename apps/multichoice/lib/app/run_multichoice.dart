import 'dart:developer';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:multichoice/app/bootstrap/bootstrap.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/crashlytics_setup.dart';
import 'package:multichoice/i18n/strings.g.dart';
import 'package:multichoice/utils/app_locale_preference.dart';
import 'package:window_size/window_size.dart';

Future<void> runMultichoice() async {
  WidgetsFlutterBinding.ensureInitialized();
  await bootstrap();
  await applySavedAppLocale();

  if (!kIsWeb && Platform.isAndroid) {
    setupCrashlytics();
  }

  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    setupCrashlytics();
  }

  try {
    if (!kIsWeb) {
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        setWindowTitle('Multichoice');
        setWindowMinSize(
          const Size(600, 400),
        );
      }
    }
  } on Exception catch (e) {
    log(e.toString());
  }

  runApp(TranslationProvider(child: Multichoice()));
}
