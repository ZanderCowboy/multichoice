part of '../../tab_layout.dart';

class _VerticalTab extends HookWidget {
  const _VerticalTab({
    required this.tab,
    this.isEditMode = false,
  });

  final TabsDTO tab;
  final bool isEditMode;

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

    return Card(
      margin: allPadding4,
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
                  children: [
                    Row(
                      children: [
                        if (isEditMode)
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
                          return ReorderableDragStartListener(
                            key: ValueKey(entry.id),
                            index: index,
                            child: EntryCard(
                              entry: entry,
                              onDoubleTap: () {},
                              isEditMode: isEditMode,
                            ),
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
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
