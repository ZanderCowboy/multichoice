part of '../home_page.dart';

class EntryCard extends StatelessWidget {
  const EntryCard({
    required this.entry,
    required this.onDoubleTap,
    required this.isLayoutVertical,
    this.isEditMode = false,
    this.dragIndex,
    super.key,
  });

  final EntryDTO entry;
  final VoidCallback onDoubleTap;
  final bool isLayoutVertical;
  final bool isEditMode;
  final int? dragIndex;

  @override
  Widget build(BuildContext context) {
    Widget? dragHandle;
    if (isEditMode && dragIndex != null) {
      dragHandle = isLayoutVertical
          ? ReorderableDragStartListener(
              index: dragIndex!,
              child: Icon(
                Icons.unfold_more,
                size: 28,
                color: context.appColorsTheme.ternary,
              ),
            )
          : ReorderableGridDelayedDragStartListener(
              index: dragIndex!,
              child: Icon(
                Icons.open_with,
                size: 28,
                color: context.appColorsTheme.ternary,
              ),
            );
    } else if (isEditMode) {
      dragHandle = Icon(
        isLayoutVertical ? Icons.unfold_more : Icons.open_with,
        size: 24,
        color: context.appColorsTheme.ternary,
      );
    }

    return GestureDetector(
      onTap: isEditMode
          ? null
          : () async {
              await coreSl<IAnalyticsService>().logEvent(
                CrudEventData(
                  page: AnalyticsPage.home,
                  entity: AnalyticsEntity.entry,
                  action: AnalyticsAction.open,
                  tabId: entry.tabId,
                  entryId: entry.id,
                ),
              );
              if (context.mounted) {
                await context.router.push(
                  DetailsPageRoute(
                    // TODO: Change type to be dynamic
                    result: SearchResult(
                      isTab: false,
                      item: entry,
                      matchScore: 0,
                    ),
                    onBack: () {
                      context.router.pop();
                    },
                  ),
                );
              }
            },
      onDoubleTap: isEditMode ? null : onDoubleTap,

      /// Disable onLongPress during edit mode so ReorderableGridDragStartListener can work
      onLongPress: isEditMode
          ? null
          : () async {
              final bloc = context.read<HomeBloc>();
              if (!bloc.state.isEditMode) {
                await _triggerEditModeHaptic();
                bloc.add(const HomeEvent.onToggleEditMode());
              }
            },
      child: Padding(
        padding: isLayoutVertical ? allPadding2 : allPadding4,
        child: Card(
          elevation: 3,
          // shadowColor: Colors.transparent,
          // surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: borderCircular5,
          ),
          margin: EdgeInsets.zero,
          color: context.appColorsTheme.secondary,
          child: Padding(
            padding: allPadding4,
            child: SizedBox(
              height: UIConstants.entryHeight(context),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.centerLeft,
                children: [
                  Opacity(
                    opacity: isEditMode ? 0.5 : 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.title,
                          style: context.appTextTheme.contrastSubtitle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        gap4,
                        Text(
                          entry.subtitle,
                          style: context.appTextTheme.contrastBody,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                  if (dragHandle != null)
                    Align(
                      alignment: isLayoutVertical
                          ? Alignment.centerLeft
                          : Alignment.topCenter,
                      child: Transform.translate(
                        offset: isLayoutVertical
                            ? Offset(
                                UIConstants.vertTabWidth(context) / 3,
                                0,
                              )
                            : Offset(0, UIConstants.horiTabHeight(context) / 8),
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
          ),
        ),
      ),
    );
  }
}
