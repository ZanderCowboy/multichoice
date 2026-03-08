part of '../../tab_layout.dart';

class _VerticalTab extends StatefulWidget {
  const _VerticalTab({
    required this.tab,
    this.isEditMode = false,
    this.dragIndex,
  });

  final TabsDTO tab;
  final bool isEditMode;
  final int? dragIndex;

  @override
  State<_VerticalTab> createState() => _VerticalTabState();
}

class _VerticalTabState extends State<_VerticalTab> {
  late final ScrollController _scrollController;
  int _previousEntriesLength = 0;
  bool _canScrollToTop = false;

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
  void didUpdateWidget(_VerticalTab oldWidget) {
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
    final shouldShow =
        maxScrollExtent > 0 && currentOffset >= scrollToStartThreshold;

    if (shouldShow != _canScrollToTop) {
      setState(() {
        _canScrollToTop = shouldShow;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLayout = context.watch<AppLayout>();
    final entries = widget.tab.entries;

    final listContent = CustomScrollView(
      controller: _scrollController,
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
              VerticalHeader(
                dragIndex: widget.dragIndex,
                isEditMode: widget.isEditMode,
                tab: widget.tab,
              ),
              SliverToBoxAdapter(
                child: Divider(
                  color: context.theme.appColors.secondaryLight,
                  thickness: 2,
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
                    return EntryCard(
                      key: ValueKey(entry.id),
                      entry: entry,
                      onDoubleTap: () {},
                      isLayoutVertical: appLayout.isLayoutVertical,
                      isEditMode: widget.isEditMode,
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
                        isLayoutVertical: appLayout.isLayoutVertical,
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
                SliverToBoxAdapter(
                  child: NewEntry(
                    tabId: widget.tab.id,
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
          if (_canScrollToTop)
            Positioned(
              top: 5,
              left: 0,
              right: 0,
              child: Center(
                child: _scrollToStartButton(
                  context: context,
                  scrollController: _scrollController,
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
