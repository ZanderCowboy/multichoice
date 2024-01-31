import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multichoice/app.dart';
import 'package:multichoice/get_it_injection.dart';
import 'package:multichoice/simple_bloc_observer.dart';
import 'package:window_size/window_size.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureCoreDependencies();
  Bloc.observer = const SimpleBlocObserver();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Multichoice');
    setWindowMinSize(
      const Size(600, 400),
    );
  }

  // await devtools.main();
  // await webdev.main([
  //   'serve',
  //   '--auto',
  //   '--release',
  //   '--web-host=0.0.0.0',
  //   '--web-port=8080',
  //   '--browser-chrome=/usr/bin/chromium-browser', // Path to Chromium executable
  // ]);

  runApp(const App());
}
