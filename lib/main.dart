import 'dart:developer';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multichoice/app.dart';
import 'package:multichoice/bloc_observer.dart';
import 'package:multichoice/get_it_injection.dart';
import 'package:window_size/window_size.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureCoreDependencies();
  Bloc.observer = const SimpleBlocObserver();

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

  runApp(const App());
}
