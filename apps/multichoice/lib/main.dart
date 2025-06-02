import 'dart:developer';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:multichoice/app/view/multichoice.dart';
import 'package:multichoice/bootstrap.dart';
import 'package:window_size/window_size.dart';

void main() async {
  await dotenv.load();
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
  } on Exception catch (e) {
    log(e.toString());
  }

  runApp(Multichoice());
}
