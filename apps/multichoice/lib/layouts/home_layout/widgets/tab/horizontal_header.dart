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
    Widget? dragHandle;
    if (isEditMode && dragIndex != null) {
      dragHandle = ReorderableDragStartListener(
        index: dragIndex!,
        child: Icon(
          Icons.unfold_more,
          size: 28,
          color: context.appColorsTheme.ternary,
        ),
      );
    } else if (isEditMode) {
      dragHandle = Icon(
        Icons.unfold_more,
        size: 28,
        color: context.appColorsTheme.ternary,
      );
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: allPadding4,
        child: SizedBox(
          width: UIConstants.horiTabHeaderWidth(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                              maxLines: 5,
                            ),
                            if (tab.subtitle.isEmpty)
                              const Expanded(child: SizedBox.shrink())
                            else
                              Expanded(
                                child: Text(
                                  tab.subtitle,
                                  style: context.appTextTheme.subtitleMedium,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 5,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (dragHandle != null)
                      Align(
                        alignment: Alignment.topCenter,
                        child: Transform.translate(
                          offset: Offset(
                            0,
                            UIConstants.horiTabHeight(context) / 3,
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
