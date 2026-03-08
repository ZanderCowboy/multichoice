part of '../../tab_layout.dart';

class HorizontalHeader extends StatelessWidget {
  const HorizontalHeader({
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
        child: SizedBox(
          width: UIConstants.horiTabHeaderWidth(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isEditMode && dragIndex != null)
                Center(
                  child: ReorderableDragStartListener(
                    index: dragIndex!,
                    child: Icon(
                      Icons.drag_handle,
                      size: 28,
                      color: context.theme.appColors.ternary,
                    ),
                  ),
                )
              else if (isEditMode)
                Center(
                  child: Icon(
                    Icons.drag_handle,
                    size: 28,
                    color: context.theme.appColors.ternary,
                  ),
                ),
              Padding(
                padding: left4,
                child: Text(
                  tab.title,
                  style: context.theme.appTextTheme.titleMedium?.copyWith(
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                ),
              ),
              if (tab.subtitle.isEmpty)
                const Expanded(child: SizedBox.shrink())
              else
                Expanded(
                  child: Padding(
                    padding: left4,
                    child: Text(
                      tab.subtitle,
                      style: context.theme.appTextTheme.subtitleMedium
                          ?.copyWith(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                    ),
                  ),
                ),
              Center(
                child: isEditMode
                    ? const SizedBox.shrink()
                    : MenuWidget(tab: tab),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
