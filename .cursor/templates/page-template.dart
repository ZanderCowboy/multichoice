// Page template — replace <Feature> with your feature name.
// Path: apps/multichoice/lib/presentation/<feature>/<feature>_page.dart
// Add route in app_router.dart and run `make db` for .gr.dart

import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multichoice/app/export.dart';

@RoutePage()
class <Feature>Page extends StatelessWidget {
  const <Feature>Page({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => coreSl<<Feature>Bloc>()..add(const <Feature>Started()),
      child: Scaffold(
        appBar: AppBar(title: const Text('<Page Title>')),
        body: const _<Feature>Page(),
      ),
    );
  }
}

class _<Feature>Page extends StatelessWidget {
  const _<Feature>Page();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<<Feature>Bloc, <Feature>State>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return const Placeholder();
      },
    );
  }
}
