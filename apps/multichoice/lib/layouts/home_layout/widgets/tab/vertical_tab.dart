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
    final canScrollToTop = useScrollToStartIndicator(
      scrollController,
      keys: [entries.length, isEditMode],
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

    final listContent = CustomScrollView(
      controller: scrollController,
      scrollBehavior: CustomScrollBehaviour(),
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        const SliverToBoxAdapter(
          child: SizedBox(height: 8),
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
                  child: Row(
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tab.title,
                              style: context.theme.appTextTheme.titleMedium,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                            if (tab.subtitle.isNotEmpty)
                              Text(
                                tab.subtitle,
                                style:
                                    context.theme.appTextTheme.subtitleMedium,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                              ),
                          ],
                        ),
                      ),
                      if (!isEditMode) MenuWidget(tab: tab),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Divider(
                  color: context.theme.appColors.secondaryLight,
                  thickness: 2,
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
                    return EntryCard(
                      key: ValueKey(entry.id),
                      entry: entry,
                      onDoubleTap: () {},
                      isEditMode: isEditMode,
                      dragIndex: index,
                    );
                  },
                )
              else ...[
                SliverPadding(
                  padding: horizontal2,
                  sliver: SliverList.builder(
                    itemCount: entries.length,
                    itemBuilder: (_, index) {
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
                SliverToBoxAdapter(
                  child: NewEntry(
                    tabId: tab.id,
                  ),
                ),
              ],
              // Keep the moving card at least viewport-high; once content grows,
              // this contributes zero and the card extends naturally.
              const SliverFillRemaining(
                hasScrollBody: false,
                child: SizedBox.shrink(),
              ),
            ],
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 8),
        ),
      ],
    );

    return SizedBox(
      width: UIConstants.vertTabWidth(context),
      child: Stack(
        children: [
          Positioned.fill(child: listContent),
          if (canScrollToTop.value)
            Positioned(
              top: 5,
              left: 0,
              right: 0,
              child: Center(
                child: _scrollToStartButton(
                  context: context,
                  scrollController: scrollController,
                  label: 'Scroll to top',
                  icon: Icons.keyboard_arrow_up,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
