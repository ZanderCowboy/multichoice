import 'package:flutter/material.dart';
import 'package:multichoice/presentation/home/home_page.dart';
import 'package:multichoice/utils/app_theme.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppTheme(),
      builder: (context, child) => MaterialApp(
        title: 'Multichoice',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: context.watch<AppTheme>().themeMode,
        home: const HomePage(),
      ),
    );
  }
}
