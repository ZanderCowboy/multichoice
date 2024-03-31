import 'package:flutter/material.dart';
import 'package:multichoice/app/engine/app_router.dart';
import 'package:multichoice/app/view/theme/app_theme.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  App({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
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
