import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';

/// A simple bloc observer
class SimpleBlocObserver extends BlocObserver {
  /// Empty constructor
  const SimpleBlocObserver();

  @override
  void onEvent(
    Bloc<dynamic, dynamic> bloc,
    Object? event,
  ) {
    super.onEvent(bloc, event);
    log('${bloc.runtimeType} $event');
  }

  @override
  void onError(
    BlocBase<dynamic> bloc,
    Object error,
    StackTrace stackTrace,
  ) {
    log('${bloc.runtimeType} $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    log('$transition');
  }
}

Future<void> bootstrap() async {
  Bloc.observer = const SimpleBlocObserver();

  await configureCoreDependencies();

  // await runZonedGuarded(
  //   () async {},
  //   (error, stackTrace) {},
  // );
}