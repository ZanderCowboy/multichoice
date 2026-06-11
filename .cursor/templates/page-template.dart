// Page template — replace <Feature> with your feature name.
// Path: apps/multichoice/lib/presentation/<feature>/<feature>_page.dart
// Add route in app_router.dart and run `make db` for .gr.dart

import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multichoice/app/export.dart';

@RoutePage()
class <Feature>Page extends StatefulWidget {
  const <Feature>Page({super.key});

  @override
  State<<Feature>Page> createState() => _<Feature>PageState();
}

class _<Feature>PageState extends State<<Feature>Page> {
  <Feature>Bloc? _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = coreSl<<Feature>Bloc>()..add(const <Feature>Started());
  }

  @override
  void dispose() {
    final bloc = _bloc;
    if (bloc != null) {
      unawaited(bloc.close());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = _bloc;
    if (bloc == null) {
      return const Scaffold(body: SizedBox.shrink());
    }

    return BlocProvider.value(
      value: bloc,
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
