part of '../../tab_layout.dart';

class VerticalHeader extends StatelessWidget {
  const VerticalHeader({
    required this.dragIndex,
    required this.isEditMode,
    required this.tab,
    super.key,
  });

  final bool isEditMode;
  final int? dragIndex;
  final TabsDTO tab;

  @override
  Widget build(BuildContext context) {
    Widget? dragHandle;
    if (isEditMode && dragIndex != null) {
      dragHandle = ReorderableDragStartListener(
        index: dragIndex!,
        child: RotatedBox(
          quarterTurns: 1,
          child: Icon(
            Icons.unfold_more,
            size: 28,
            color: context.theme.appColors.ternary,
          ),
        ),
      );
    } else if (isEditMode) {
      dragHandle = RotatedBox(
        quarterTurns: 1,
        child: Icon(
          Icons.unfold_more,
          size: 28,
          color: context.theme.appColors.ternary,
        ),
      );
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: allPadding4,
        child: Row(
          children: [
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.centerLeft,
                children: [
                  Opacity(
                    opacity: isEditMode ? 0.25 : 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tab.title,
                            style: context.appTextTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                          if (tab.subtitle.isNotEmpty)
                            Text(
                              tab.subtitle,
                              style: context.appTextTheme.subtitleMedium,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (dragHandle != null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Transform.translate(
                        offset: Offset(
                          UIConstants.vertTabWidth(context) / 3,
                          0,
                        ),
                        child: SizedBox(
                          height: 36,
                          width: 36,
                          child: Center(child: dragHandle),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (!isEditMode) MenuWidget(tab: tab),
          ],
        ),
      ),
    );
  }
}
