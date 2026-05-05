import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/presentation/home/home_page.dart';
import 'package:ui_kit/ui_kit.dart';

enum TabHeaderLayout {
  horizontal,
  vertical,
}

class TabHeader extends StatelessWidget {
  const TabHeader({
    required this.tab,
    required this.isEditMode,
    required this.layout,
    this.dragIndex,
    super.key,
  });

  final TabsDTO tab;
  final bool isEditMode;
  final int? dragIndex;
  final TabHeaderLayout layout;

  @override
  Widget build(BuildContext context) {
    switch (layout) {
      case TabHeaderLayout.horizontal:
        return _buildHorizontalHeader(context);
      case TabHeaderLayout.vertical:
        return _buildVerticalHeader(context);
    }
  }

  Widget _buildHorizontalHeader(BuildContext context) {
    return SizedBox(
      width: UIConstants.horiTabHeaderWidth(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isEditMode && dragIndex != null)
                Padding(
                  padding: right4,
                  child: ReorderableDragStartListener(
                    index: dragIndex!,
                    child: Icon(
                      Icons.drag_handle,
                      size: 20,
                      color: context.theme.appColors.ternary,
                    ),
                  ),
                )
              else if (isEditMode)
                Padding(
                  padding: right4,
                  child: Icon(
                    Icons.drag_handle,
                    size: 20,
                    color: context.theme.appColors.ternary,
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: left4,
                  child: Text(
                    tab.title,
                    style: context.theme.appTextTheme.titleMedium?.copyWith(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (tab.subtitle.isEmpty)
            const SizedBox.shrink()
          else
            Expanded(
              child: Padding(
                padding: left4,
                child: Text(
                  tab.subtitle,
                  style: context.theme.appTextTheme.subtitleMedium?.copyWith(
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          Center(
            child: isEditMode ? const SizedBox.shrink() : MenuWidget(tab: tab),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalHeader(BuildContext context) {
    return Padding(
      padding: left4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isEditMode && dragIndex != null)
                Padding(
                  padding: right4,
                  child: ReorderableDragStartListener(
                    index: dragIndex!,
                    child: Icon(
                      Icons.drag_handle,
                      size: 20,
                      color: context.theme.appColors.ternary,
                    ),
                  ),
                )
              else if (isEditMode)
                Padding(
                  padding: right4,
                  child: Icon(
                    Icons.drag_handle,
                    size: 20,
                    color: context.theme.appColors.ternary,
                  ),
                ),
              Expanded(
                child: Text(
                  tab.title,
                  style: context.theme.appTextTheme.titleMedium,
                ),
              ),
              if (!isEditMode) MenuWidget(tab: tab),
            ],
          ),
          if (tab.subtitle.isNotEmpty)
            Text(
              tab.subtitle,
              style: context.theme.appTextTheme.subtitleMedium,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            )
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }
}
