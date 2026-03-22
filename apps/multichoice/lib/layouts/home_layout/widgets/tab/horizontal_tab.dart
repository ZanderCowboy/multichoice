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
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _previousEntriesLength = widget.tab.entries.length;
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _isDisposed) return;
      _refreshScrollIndicators();
    });
  }

  @override
  void didUpdateWidget(_HorizontalTab oldWidget) {
    super.didUpdateWidget(oldWidget);

    final entries = widget.tab.entries;
    if (entries.length > _previousEntriesLength) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted || _isDisposed || !_scrollController.hasClients) return;
        await _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
    _previousEntriesLength = entries.length;

    if (entries.length != oldWidget.tab.entries.length ||
        widget.isEditMode != oldWidget.isEditMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _isDisposed) return;
        _refreshScrollIndicators();
      });
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    _refreshScrollIndicators();
  }

  void _refreshScrollIndicators() {
    if (!mounted || _isDisposed || !_scrollController.hasClients) return;

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
    final appLayout = context.watch<AppLayout>();
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
            color: context.theme.appColors.iconColor?.withValues(alpha: 0.8),
            borderRadius: borderCircular12,
          ),
          sliver: SliverMainAxisGroup(
            slivers: [
              HorizontalHeader(
                dragIndex: widget.dragIndex,
                isEditMode: widget.isEditMode,
                tab: widget.tab,
              ),
              SliverToBoxAdapter(
                child: VerticalDivider(
                  color: context.theme.appColors.textTertiary,
                  thickness: 2,
                  width: 8,
                  indent: 0,
                  endIndent: 0,
                ),
              ),
              if (widget.isEditMode && entries.isNotEmpty)
                ReorderableEntriesGrid(
                  entries: entries,
                  tabId: widget.tab.id,
                  isLayoutVertical: appLayout.isLayoutVertical,
                  isEditMode: widget.isEditMode,
                  dragIndex: widget.dragIndex,
                )
              else
                EntriesGrid(
                  entries: entries,
                  isEditMode: widget.isEditMode,
                  isLayoutVertical: appLayout.isLayoutVertical,
                  tabId: widget.tab.id,
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
