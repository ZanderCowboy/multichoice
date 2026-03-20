import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/app/view/auth/auth_notifier.dart';
import 'package:multichoice/app/view/theme/app_theme.dart';
import 'package:provider/provider.dart';

class Multichoice extends StatelessWidget {
  Multichoice({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => AppTheme(),
        ),
        ChangeNotifierProvider(
          create: (context) => AppLayout(),
        ),
        BlocProvider(
          create: (_) => coreSl<HomeBloc>()
            ..add(
              const HomeEvent.onGetTabs(),
            ),
        ),
      ],
      builder: (context, child) => MaterialApp.router(
        title: 'Multichoice',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: context.watch<AppTheme>().themeMode,
        debugShowCheckedModeBanner: false,
        routerConfig: _appRouter.config(),
        builder: (context, child) => ColoredBox(
          color:
              context.theme.appColors.foreground ??
              Theme.of(context).scaffoldBackgroundColor,
          child: child ?? const SizedBox.shrink(),
        ),
      ),
    );
  }
}
