import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/presentation/home/home_page.dart';
import 'package:ui_kit/ui_kit.dart';

part 'widgets/home/horizontal_home.dart';
part 'widgets/home/vertical_home.dart';

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

    if (state.errorMessage?.isNotEmpty ?? false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.errorMessage ?? 'Error'),
            backgroundColor: context.theme.appColors.error,
          ),
        );
      });
    }

    return Center(
      child: appLayout.isLayoutVertical
          ? const _VerticalHome()
          : const _HorizontalHome(),
    );
  }
}
