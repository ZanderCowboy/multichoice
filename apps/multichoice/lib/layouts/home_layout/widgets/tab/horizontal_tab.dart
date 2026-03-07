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
    final canScrollToStart = useScrollToStartIndicator(
      scrollController,
      keys: [entries.length, isEditMode],
      showAfterOffset: UIConstants.horiTabHeaderWidth(context),
    );

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

    final horizontalContent = CustomScrollView(
      scrollDirection: Axis.horizontal,
      controller: scrollController,
      scrollBehavior: CustomScrollBehaviour(),
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        const SliverToBoxAdapter(
          child: SizedBox(width: 8),
        ),
        DecoratedSliver(
          decoration: BoxDecoration(
            color: context.theme.appColors.primary?.withValues(alpha: 0.8),
            borderRadius: borderCircular12,
          ),
          sliver: SliverMainAxisGroup(
            slivers: [
              SliverToBoxAdapter(
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
                            style: context.theme.appTextTheme.titleMedium
                                ?.copyWith(
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
              ),
              SliverToBoxAdapter(
                child: VerticalDivider(
                  color: context.theme.appColors.secondaryLight,
                  thickness: 2,
                  width: 8,
                  indent: 0,
                  endIndent: 0,
                ),
              ),
              if (isEditMode && entries.isNotEmpty)
                SliverReorderableList(
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
                SliverPadding(
                  padding: vertical4,
                  sliver: SliverGrid.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                ),
              // Keep the moving card at least viewport-wide; once content grows,
              // this contributes zero and the card extends naturally.
              const SliverFillRemaining(
                hasScrollBody: false,
                child: SizedBox.shrink(),
              ),
            ],
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(width: 8),
        ),
      ],
    );

    return SizedBox(
      height: UIConstants.horiTabHeight(context),
      child: Stack(
        children: [
          Positioned.fill(child: horizontalContent),
          if (canScrollToStart.value)
            Positioned(
              left: 5,
              top: 0,
              bottom: 0,
              child: Center(
                child: _scrollToStartButton(
                  context: context,
                  scrollController: scrollController,
                  label: 'Scroll to start',
                  icon: Icons.keyboard_arrow_left,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
