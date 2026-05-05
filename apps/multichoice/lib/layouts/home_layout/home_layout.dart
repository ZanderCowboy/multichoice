import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/layouts/home_layout/widgets/home/drag_scroll_scope.dart';
import 'package:multichoice/presentation/home/home_page.dart';
import 'package:ui_kit/ui_kit.dart';

part 'widgets/home/horizontal_home.dart';
part 'widgets/home/vertical_home.dart';
part 'widgets/home/edit_mode_helper_banner.dart';
part 'widgets/_on_home_refresh.dart';

class HomeLayout extends StatelessWidget {
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
      child: appLayout.isLayoutVertical
          ? const _VerticalHome()
          : const _HorizontalHome(),
    );
  }
}
