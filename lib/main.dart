import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multichoice/app.dart';
import 'package:multichoice/get_it_injection.dart';
import 'package:multichoice/simple_bloc_observer.dart';
import 'package:window_size/window_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureCoreDependencies();
  Bloc.observer = const SimpleBlocObserver();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Multichoice');
    setWindowMinSize(
      const Size(600, 400),
    );
  }

  runApp(const App());
}
