import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:multichoice/app/engine/app_router.dart';
import 'package:multichoice/app/view/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatelessWidget {
  App({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    final sharedPref = coreSl<SharedPreferences>();
    final systemBrightness = MediaQuery.platformBrightnessOf(context);
    final isDarkMode = systemBrightness == Brightness.dark;

    if (sharedPref.getString('theme') == 'light' && isDarkMode) {
      sharedPref.setString('theme', 'dark');
    }

    return ChangeNotifierProvider(
      create: (context) => AppTheme(),
      builder: (context, child) => MaterialApp.router(
        title: 'Multichoice',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: context.watch<AppTheme>().themeMode,
        debugShowCheckedModeBanner: false,
        routerConfig: _appRouter.config(),
      ),
    );
  }
}
