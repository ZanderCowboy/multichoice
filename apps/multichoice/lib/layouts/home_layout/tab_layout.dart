import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/layouts/home_layout/widgets/tab/horizontal_tab.dart';
import 'package:multichoice/layouts/home_layout/widgets/tab/vertical_tab.dart';
import 'package:ui_kit/ui_kit.dart';

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
        ? VerticalTab(
            tab: tab,
            isEditMode: isEditMode,
            dragIndex: dragIndex,
          )
        : HorizontalTab(
            tab: tab,
            isEditMode: isEditMode,
            dragIndex: dragIndex,
          );
  }
}
