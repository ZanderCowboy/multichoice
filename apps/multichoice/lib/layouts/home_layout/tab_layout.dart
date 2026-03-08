import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/presentation/home/home_page.dart';
import 'package:reorderable_grid/reorderable_grid.dart';
import 'package:ui_kit/ui_kit.dart';

part 'widgets/tab/horizontal_tab.dart';
part 'widgets/tab/scroll_indicator_hook.dart';
part 'widgets/tab/vertical_tab.dart';
part 'widgets/tab/reorderable_entries_grid.dart';
part 'widgets/tab/entries_grid.dart';
part 'widgets/tab/horizontal_header.dart';
part 'widgets/tab/vertical_header.dart';

class TabLayout extends StatelessWidget {
  const TabLayout({
    required this.tab,
    this.isEditMode = false,
    this.dragIndex,
    super.key,
  });

  final TabsDTO tab;
  final bool isEditMode;
  final int? dragIndex;

  @override
  Widget build(BuildContext context) {
    final appLayout = context.watch<AppLayout>();

    if (!appLayout.isInitialized) {
      return CircularLoader.small();
    }

    return appLayout.isLayoutVertical
        ? _VerticalTab(
            tab: tab,
            isEditMode: isEditMode,
            dragIndex: dragIndex,
          )
        : _HorizontalTab(
            tab: tab,
            isEditMode: isEditMode,
            dragIndex: dragIndex,
          );
  }
}
