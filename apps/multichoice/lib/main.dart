import 'dart:developer';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:multichoice/app/view/app.dart';
import 'package:multichoice/bootstrap.dart';
import 'package:window_size/window_size.dart';

void main() async {
  await bootstrap();

  try {
    if (!kIsWeb) {
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        setWindowTitle('Multichoice');
        setWindowMinSize(
          const Size(600, 400),
        );
      }
    }
  } catch (e) {
    log(e.toString());
  }

  runApp(App());
}
