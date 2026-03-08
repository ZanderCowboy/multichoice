part of '../../tab_layout.dart';

class _HorizontalTab extends StatefulWidget {
  const _HorizontalTab({
    required this.tab,
    this.isEditMode = false,
    this.dragIndex,
  });

  final TabsDTO tab;
  final bool isEditMode;
  final int? dragIndex;

  @override
  State<_HorizontalTab> createState() => _HorizontalTabState();
}

class _HorizontalTabState extends State<_HorizontalTab> {
  late final ScrollController _scrollController;
  int _previousEntriesLength = 0;
  bool _canScrollToStart = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _previousEntriesLength = widget.tab.entries.length;
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshScrollIndicators();
    });
  }

  @override
  void didUpdateWidget(_HorizontalTab oldWidget) {
    super.didUpdateWidget(oldWidget);

    final entries = widget.tab.entries;
    if (entries.length > _previousEntriesLength) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (_scrollController.hasClients) {
          await _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
    _previousEntriesLength = entries.length;

    if (entries.length != oldWidget.tab.entries.length ||
        widget.isEditMode != oldWidget.isEditMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _refreshScrollIndicators();
      });
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    _refreshScrollIndicators();
  }

  void _refreshScrollIndicators() {
    if (!_scrollController.hasClients) return;

    final maxScrollExtent = _scrollController.position.maxScrollExtent;
    final currentOffset = _scrollController.offset;
    final showAfterOffset = UIConstants.horiTabHeaderWidth(context);
    final shouldShow = maxScrollExtent > 0 && currentOffset >= showAfterOffset;

    if (shouldShow != _canScrollToStart) {
      setState(() {
        _canScrollToStart = shouldShow;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final entries = widget.tab.entries;

    final horizontalContent = CustomScrollView(
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
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
                        if (widget.isEditMode && widget.dragIndex != null)
                          Center(
                            child: ReorderableDragStartListener(
                              index: widget.dragIndex!,
                              child: Icon(
                                Icons.drag_handle,
                                size: 28,
                                color: context.theme.appColors.ternary,
                              ),
                            ),
                          )
                        else if (widget.isEditMode)
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
                            widget.tab.title,
                            style: context.theme.appTextTheme.titleMedium
                                ?.copyWith(
                                  fontSize: 16,
                                ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                          ),
                        ),
                        if (widget.tab.subtitle.isEmpty)
                          const Expanded(child: SizedBox.shrink())
                        else
                          Expanded(
                            child: Padding(
                              padding: left4,
                              child: Text(
                                widget.tab.subtitle,
                                style: context.theme.appTextTheme.subtitleMedium
                                    ?.copyWith(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                              ),
                            ),
                          ),
                        Center(
                          child: widget.isEditMode
                              ? const SizedBox.shrink()
                              : MenuWidget(tab: widget.tab),
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
              if (widget.isEditMode && entries.isNotEmpty)
                SliverReorderableList(
                  itemCount: entries.length,
                  onReorder: (oldIndex, newIndex) {
                    context.read<HomeBloc>().add(
                      HomeEvent.onReorderEntries(
                        widget.tab.id,
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
                        isEditMode: widget.isEditMode,
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
                          tabId: widget.tab.id,
                        );
                      }

                      final entry = entries[index];

                      return EntryCard(
                        entry: entry,
                        isEditMode: widget.isEditMode,
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
          if (_canScrollToStart)
            Positioned(
              left: 5,
              top: 0,
              bottom: 0,
              child: Center(
                child: _scrollToStartButton(
                  context: context,
                  scrollController: _scrollController,
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
