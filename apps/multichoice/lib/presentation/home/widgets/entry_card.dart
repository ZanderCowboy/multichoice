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
    return GestureDetector(
      onTap: isEditMode
          ? null
          : () async {
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
            },
      onDoubleTap: isEditMode ? null : onDoubleTap,
      onLongPress: () async {
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
          shadowColor: context.theme.appColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: borderCircular5,
          ),
          margin: EdgeInsets.zero,
          color: context.theme.appColors.secondary,
          child: Padding(
            padding: allPadding4,
            child: SizedBox(
              height: UIConstants.entryHeight(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isEditMode && dragIndex != null)
                        Padding(
                          padding: horizontal4,
                          child: ReorderableDragStartListener(
                            index: dragIndex!,
                            child: Icon(
                              Icons.drag_handle,
                              size: 24,
                              color: context.theme.appColors.ternary,
                            ),
                          ),
                        )
                      else if (isEditMode)
                        Padding(
                          padding: horizontal4,
                          child: Icon(
                            Icons.drag_handle,
                            size: 24,
                            color: context.theme.appColors.ternary,
                          ),
                        ),
                      Expanded(
                        child: Text(
                          entry.title,
                          style: context.theme.appTextTheme.titleSmall
                              ?.copyWith(
                                fontSize: 16,
                                letterSpacing: 0.3,
                                height: 1,
                              ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  gap4,
                  Text(
                    entry.subtitle,
                    style: context.theme.appTextTheme.subtitleSmall?.copyWith(
                      fontSize: 12,
                      letterSpacing: 0.5,
                      height: 1.25,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
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
