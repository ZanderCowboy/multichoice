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
    final hasVerticalOverflow = useState(false);
    final canScrollToTop = useState(false);

    void refreshScrollIndicators() {
      if (!scrollController.hasClients) {
        return;
      }

      final maxScrollExtent = scrollController.position.maxScrollExtent;
      final currentOffset = scrollController.offset;
      hasVerticalOverflow.value = maxScrollExtent > 0;
      canScrollToTop.value = maxScrollExtent > 0 && currentOffset > 12;
    }

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

    useEffect(
      () {
        void listener() {
          refreshScrollIndicators();
        }

        scrollController.addListener(listener);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          refreshScrollIndicators();
        });

        return () {
          scrollController.removeListener(listener);
        };
      },
      [entries.length, isEditMode],
    );

    final listContent = isEditMode && entries.isNotEmpty
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
                            HomeEvent.onUpdateEntry(entry.id),
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
              SliverToBoxAdapter(
                child: NewEntry(
                  tabId: tab.id,
                ),
              ),
            ],
          );

    return Card(
      margin: allPadding4,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      color: context.theme.appColors.primary,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isEditMode && dragIndex != null)
                          Padding(
                            padding: horizontal4,
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
                          Padding(
                            padding: horizontal4,
                            child: Icon(
                              Icons.drag_handle,
                              size: 28,
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
                child: Stack(
                  children: [
                    Positioned.fill(child: listContent),
                    if (hasVerticalOverflow.value && canScrollToTop.value)
                      Positioned(
                        top: 5,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Material(
                            color: context.theme.appColors.white,
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () async {
                                await scrollController.animateTo(
                                  0,
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeOut,
                                );
                              },
                              child: Padding(
                                padding: allPadding2,
                                child: Icon(
                                  Icons.keyboard_arrow_up,
                                  size: 16,
                                  color: context.theme.appColors.ternary,
                                ),
                              ),
                            ),
                          ),
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
  }
}
