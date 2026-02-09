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

/// Extension to handle home refresh functionality
extension _HomeRefreshHelper on BuildContext {
  /// Performs a home refresh and shows a success message
  Future<void> performHomeRefresh() async {
    final bloc = read<HomeBloc>();
    bloc.add(const HomeEvent.refresh());

    // Wait for the refresh to complete by listening to state changes
    try {
      await bloc.stream
          .firstWhere((state) => !state.isLoading)
          .timeout(const Duration(seconds: 5));

      if (mounted) {
        ScaffoldMessenger.of(this).showSnackBar(
          SnackBar(
            content: const Text('Refreshed.'),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: theme.appColors.surface.withOpacity(0.9),
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
          ),
        );
      }
    } on TimeoutException {
      // Refresh took too long, but don't show error to user
      // The error listener will handle any actual errors
    }
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
