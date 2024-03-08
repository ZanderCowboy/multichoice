import 'package:flutter/material.dart';
import 'package:multichoice/app/engine/app_router.dart';

class App extends StatelessWidget {
  App({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Multichoice',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      routerConfig: _appRouter.config(),
    );
  }
}
