part of '../../tab_layout.dart';

class _VerticalTab extends HookWidget {
  const _VerticalTab({
    required this.tab,
    this.isEditMode = false,
    this.dragIndex,
  });

  final TabsDTO tab;
  final bool isEditMode;
  final int? dragIndex;

  @override
  Widget build(BuildContext context) {
    final entries = tab.entries;
    final scrollController = useScrollController();
    final previousEntriesLength = useState(entries.length);

    useEffect(
      () {
        if (entries.length > previousEntriesLength.value) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          });
        }
        previousEntriesLength.value = entries.length;
        return null;
      },
      [entries.length],
    );

    return DragTarget<({EntryDTO entry, int fromTabId})>(
      onWillAcceptWithDetails: (details) {
        final data = details.data;
        // Only allow drops in edit mode and when the entry comes from
        // a different tab to avoid conflicting with in-tab reordering.
        return isEditMode && data.fromTabId != tab.id;
      },
      onAcceptWithDetails: (details) {
        if (!isEditMode) return;
        final data = details.data;
        final entry = data.entry;

        // For now, append the entry at the end of the destination tab.
        final insertIndex = entries.length;

        context.read<HomeBloc>().add(
              HomeEvent.onMoveEntryToTab(
                entry.id,
                data.fromTabId,
                tab.id,
                insertIndex,
              ),
            );
      },
      builder: (context, candidateData, rejectedData) {
        final isActiveDropTarget =
            isEditMode && candidateData.isNotEmpty;

        return Card(
          margin: allPadding4,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          color: context.theme.appColors.primary,
          shape: RoundedRectangleBorder(
            side: isActiveDropTarget
                ? BorderSide(
                    color: context.theme.appColors.ternary ??
                        Colors.transparent,
                    width: 2,
                  )
                : BorderSide.none,
            borderRadius: borderCircular5,
          ),
          child: Padding(
            padding: allPadding2,
            child: SizedBox(
              width: UIConstants.vertTabWidth(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
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
                  ),
                  Divider(
                    color: context.theme.appColors.secondaryLight,
                    thickness: 2,
                    indent: 4,
                    endIndent: 4,
                  ),
                  gap4,
                  Expanded(
                    child: isEditMode && entries.isNotEmpty
                        ? ReorderableListView.builder(
                            scrollController: scrollController,
                            buildDefaultDragHandles: false,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: entries.length,
                            onReorder: (oldIndex, newIndex) {
                              context.read<HomeBloc>().add(
                                    HomeEvent.onReorderEntries(
                                      tab.id,
                                      oldIndex,
                                      newIndex,
                                    ),
                                  );
                            },
                            itemBuilder: (_, index) {
                              final entry = entries[index];
                              return EntryCard(
                                key: ValueKey(entry.id),
                                entry: entry,
                                onDoubleTap: () {},
                                isEditMode: isEditMode,
                                dragIndex: index,
                              );
                            },
                          )
                        : CustomScrollView(
                            controller: scrollController,
                            scrollBehavior: CustomScrollBehaviour(),
                            slivers: [
                              SliverList.builder(
                                itemCount: entries.length,
                                itemBuilder: (_, index) {
                                  final entry = entries[index];

                                  return BlocBuilder<HomeBloc, HomeState>(
                                    builder: (context, _) {
                                      return EntryCard(
                                        entry: entry,
                                        isEditMode: isEditMode,
                                        onDoubleTap: () async {
                                          context.read<HomeBloc>().add(
                                                HomeEvent.onUpdateEntry(
                                                  entry.id,
                                                ),
                                              );
                                          await context.router.push(
                                            EditEntryPageRoute(ctx: context),
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                              if (!isEditMode)
                                SliverToBoxAdapter(
                                  child: NewEntry(
                                    tabId: tab.id,
                                  ),
                                ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
