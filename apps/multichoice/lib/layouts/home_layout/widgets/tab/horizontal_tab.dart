part of '../../tab_layout.dart';

class _HorizontalTab extends HookWidget {
  const _HorizontalTab({
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

    return Card(
      margin: allPadding4,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      color: context.theme.appColors.primary,
      child: Padding(
        padding: allPadding2,
        child: SizedBox(
          height: UIConstants.horiTabHeight(context),
          child: CustomScrollView(
            scrollDirection: Axis.horizontal,
            controller: scrollController,
            scrollBehavior: CustomScrollBehaviour(),
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  width: UIConstants.horiTabHeaderWidth(context),
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
                            child: Padding(
                              padding: left4,
                              child: Text(
                                tab.title,
                                style: context.theme.appTextTheme.titleMedium
                                    ?.copyWith(
                                      fontSize: 16,
                                    ),
                              ),
                            ),
                          ),
                        ],
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
              SliverToBoxAdapter(
                child: VerticalDivider(
                  color: context.theme.appColors.secondaryLight,
                  thickness: 2,
                  indent: 4,
                  endIndent: 4,
                ),
              ),
              if (isEditMode && entries.isNotEmpty)
                SliverReorderableList(
                  itemCount: entries.length,
                  onReorder: (oldIndex, newIndex) {
                    context.read<HomeBloc>().add(
                      HomeEvent.onReorderEntries(tab.id, oldIndex, newIndex),
                    );
                  },
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return SizedBox(
                      key: ValueKey(entry.id),
                      width: UIConstants.horiTabHeight(context) / 2,
                      child: EntryCard(
                        entry: entry,
                        onDoubleTap: () {},
                        isEditMode: isEditMode,
                        dragIndex: index,
                      ),
                    );
                  },
                )
              else
                SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: entries.length + 1,
                  itemBuilder: (context, index) {
                    if (index == entries.length) {
                      return NewEntry(
                        tabId: tab.id,
                      );
                    }

                    final entry = entries[index];

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
                ),
            ],
          ),
        ),
      ),
    );
  }
}
