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
    return SliverToBoxAdapter(
      child: Padding(
        padding: allPadding4,
        child: Row(
          children: [
            if (isEditMode && dragIndex != null)
              Center(
                child: ReorderableDragStartListener(
                  index: dragIndex!,
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: Icon(
                      Icons.unfold_more,
                      size: 28,
                      color: context.theme.appColors.ternary,
                    ),
                  ),
                ),
              )
            else if (isEditMode)
              Center(
                child: RotatedBox(
                  quarterTurns: 1,
                  child: Icon(
                    Icons.unfold_more,
                    size: 28,
                    color: context.theme.appColors.ternary,
                  ),
                ),
              ),
            Expanded(
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
            if (!isEditMode) MenuWidget(tab: tab),
          ],
        ),
      ),
    );
  }
}
