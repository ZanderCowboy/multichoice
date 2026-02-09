import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/presentation/home/home_page.dart';
import 'package:ui_kit/ui_kit.dart';

part 'widgets/home/horizontal_home.dart';
part 'widgets/home/vertical_home.dart';

Future<void> _onHomeRefresh(BuildContext context) async {
  final bloc = context.read<HomeBloc>()..add(const HomeEvent.refresh());

  try {
    await bloc.stream
        .firstWhere((state) => !state.isLoading)
        .timeout(const Duration(seconds: 5));

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Refreshed',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: context.theme.appColors.ternary,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              gap8,
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                child: Icon(
                  Icons.close,
                  color: context.theme.appColors.ternary,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.fixed,
      ),
    );
  } on TimeoutException {
    // Refresh took too long; actual errors are handled by the error listener
  }
}

class HomeLayout extends HookWidget {
  const HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final appLayout = context.watch<AppLayout>();
    final state = context.watch<HomeBloc>().state;
    final tabs = state.tabs ?? [];

    if (!appLayout.isInitialized || (tabs.isEmpty && state.isLoading)) {
      return CircularLoader.medium();
    }

    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state.errorMessage?.isNotEmpty ?? false) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Error'),
              backgroundColor: context.theme.appColors.error,
            ),
          );
        }
      },
      child: Center(
        child: appLayout.isLayoutVertical
            ? const _VerticalHome()
            : const _HorizontalHome(),
      ),
    );
  }
}
