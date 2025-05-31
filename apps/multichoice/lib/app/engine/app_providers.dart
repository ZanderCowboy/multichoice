import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppProviders {
  AppProviders({
    required this.child,
  });

  final Widget child;

  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => coreSl<TourBloc>()
            ..add(
              const TourEvent.initialize(),
            ),
        ),
        BlocProvider(
          create: (_) => coreSl<HomeBloc>()
            ..add(
              const HomeEvent.onGetTabs(),
            ),
        ),
      ],
      child: child,
    );
  }
}
