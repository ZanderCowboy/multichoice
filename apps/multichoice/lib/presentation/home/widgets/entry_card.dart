part of '../home_page.dart';

class EntryCard extends HookWidget {
  const EntryCard({
    required this.entry,
    required this.onDoubleTap,
    this.isEditMode = false,
    this.dragIndex,
    super.key,
  });

  final EntryDTO entry;
  final VoidCallback onDoubleTap;
  final bool isEditMode;
  final int? dragIndex;

  @override
  Widget build(BuildContext context) {
    final menuController = MenuController();
    final appLayout = context.watch<AppLayout>();

    if (!appLayout.isInitialized) {
      return CircularLoader.small();
    }

    final isLayoutVertical = appLayout.isLayoutVertical;

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final card = MenuAnchor(
          controller: menuController,
          consumeOutsideTap: true,
          builder: (context, controller, child) {
            return child ?? const SizedBox.shrink();
          },
          menuChildren: [
            MenuItemButton(
              onPressed: () async {
                context.read<HomeBloc>().add(
                  HomeEvent.onUpdateEntry(entry.id),
                );
                await context.router.push(EditEntryPageRoute(ctx: context));
              },
              child: Text(MenuItems.edit.name),
            ),
            MenuItemButton(
              onPressed: () => _onDeleteEntry(context),
              child: Text(MenuItems.delete.name),
            ),
          ],
          child: GestureDetector(
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
                          context.read<HomeBloc>().add(
                            const HomeEvent.refresh(),
                          );
                          context.router.pop();
                        },
                      ),
                    );
                  },
            onDoubleTap: isEditMode ? null : onDoubleTap,
            onLongPress: isEditMode
                ? null
                : () {
                    if (menuController.isOpen) {
                      menuController.close();
                    } else {
                      menuController.open();
                    }
                  },
            child: Padding(
              padding: isLayoutVertical ? allPadding2 : allPadding4,
              child: Card(
                elevation: 3,
                shadowColor: Colors.grey[400],
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
                          children: [
                            if (isEditMode && dragIndex != null)
                              Padding(
                                padding: right4,
                                child: ReorderableDragStartListener(
                                  index: dragIndex!,
                                  child: Icon(
                                    Icons.drag_handle,
                                    size: 16,
                                    color: context.theme.appColors.ternary,
                                  ),
                                ),
                              )
                            else if (isEditMode)
                              Padding(
                                padding: right4,
                                child: Icon(
                                  Icons.drag_handle,
                                  size: 16,
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
                          style: context.theme.appTextTheme.subtitleSmall
                              ?.copyWith(
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
          ),
        );

        if (!isEditMode) {
          return card;
        }

        // In edit mode, make the entry card draggable so it can be moved
        // between tabs (collections). Report drag position when a scope is
        // present so the layout can edge-scroll (vertical: left/right,
        // horizontal: top/bottom).
        final dragScrollScope = DragScrollScope.maybeOf(context);
        final useEdgeScroll = isEditMode && dragScrollScope != null;

        return LongPressDraggable<({EntryDTO entry, int fromTabId})>(
          data: (entry: entry, fromTabId: entry.tabId),
          onDragStarted: useEdgeScroll ? dragScrollScope.onDragStarted : null,
          onDragEnd: useEdgeScroll
              ? (_) => dragScrollScope.onDragEnd()
              : null,
          onDragUpdate: useEdgeScroll
              ? (details) => dragScrollScope.onDragUpdate(details.globalPosition)
              : null,
          feedback: Material(
            color: Colors.transparent,
            child: SizedBox(
              width: isLayoutVertical
                  ? UIConstants.vertTabWidth(context) - 4
                  : UIConstants.horiTabHeight(context) / 2,
              child: card,
            ),
          ),
          childWhenDragging: const SizedBox.shrink(),
          child: card,
        );
      },
    );
  }

  void _onDeleteEntry(BuildContext context) {
    deleteModal(
      context: context,
      title: entry.title,
      content: Text(
        "Are you sure you want to delete ${entry.title} and all it's data?",
      ),
      onConfirm: () {
        context.read<HomeBloc>().add(
          HomeEvent.onLongPressedDeleteEntry(
            entry.tabId,
            entry.id,
          ),
        );
        Navigator.of(context).pop();
      },
    );
  }
}
