import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/app/view/auth/auth_notifier.dart';
import 'package:multichoice/app/view/theme/app_theme.dart';
import 'package:multichoice/i18n/strings.g.dart';
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
        onGenerateTitle: (context) => context.t.appTitle,
        theme: AppTheme.lightThemeData,
        darkTheme: AppTheme.darkThemeData,
        themeMode: context.watch<AppTheme>().themeMode,
        locale: TranslationProvider.of(context).flutterLocale,
        supportedLocales: AppLocaleUtils.supportedLocales,
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        debugShowCheckedModeBanner: false,
        routerConfig: _appRouter.config(),
        builder: (context, child) => ColoredBox(
          color:
              context.theme.appColors.appBarBackground ??
              Theme.of(context).scaffoldBackgroundColor,
          child: child ?? const SizedBox.shrink(),
        ),
      ),
    );
  }
}
