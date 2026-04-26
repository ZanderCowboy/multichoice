part of '../../home_layout.dart';

class _VerticalHome extends StatefulWidget {
  const _VerticalHome();

  @override
  State<_VerticalHome> createState() => _VerticalHomeState();
}

class _VerticalHomeState extends State<_VerticalHome> {
  late final ScrollController _scrollController;
  final GlobalKey _viewportKey = GlobalKey();
  Timer? _edgeScrollTimer;

  bool _isDragging = false;
  Offset? _dragPosition;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _edgeScrollTimer = Timer.periodic(
      const Duration(milliseconds: 50),
      (_) => _tickEdgeScroll(),
    );
  }

  @override
  void dispose() {
    _edgeScrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _tickEdgeScroll() {
    if (!_isDragging) return;
    final pos = _dragPosition;
    if (pos == null || !_scrollController.hasClients) return;

    final ctx = _viewportKey.currentContext;
    if (ctx == null || !ctx.mounted) return;

    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;

    final viewportRect = box.localToGlobal(Offset.zero) & box.size;
    final position = _scrollController.position;

    const zone = 80.0;
    const step = 12.0;

    if (pos.dx < viewportRect.left + zone) {
      final newOffset = (position.pixels - step).clamp(
        position.minScrollExtent,
        position.maxScrollExtent,
      );
      _scrollController.jumpTo(newOffset);
    } else if (pos.dx > viewportRect.right - zone) {
      final newOffset = (position.pixels + step).clamp(
        position.minScrollExtent,
        position.maxScrollExtent,
      );
      _scrollController.jumpTo(newOffset);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listenWhen: (previous, current) {
        // Only proceed if we have both previous and current tabs
        if (previous.tabs == null || current.tabs == null) return false;

        // Check if we're adding a new tab at the end
        final oldLength = previous.tabs!.length;
        final newLength = current.tabs!.length;

        // Only trigger if we added exactly one tab and it's at the end
        return newLength == oldLength + 1;
      },
      listener: (context, state) {
        if (state.tabs != null && state.tabs!.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (!mounted || !_scrollController.hasClients) return;
            await _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          });
        }
      },
      builder: (context, state) {
        final tabs = state.tabs ?? [];
        final isEditMode = state.isEditMode;

        if (isEditMode && tabs.isNotEmpty) {
          // Use ReorderableListView with horizontal scrolling for edit mode.
          // Wrap in DragScrollScope and overlay so dragging near edges scrolls.
          final theme = Theme.of(context);
          if (false) {
          void onDragStarted() {
            isDraggingRef.value = true;
          }

          void onDragEnd() {
            isDraggingRef.value = false;
            dragPositionRef.value = null;
          }

          void onDragUpdate(Offset globalPosition) {
            dragPositionRef.value = globalPosition;
          }

          return DragScrollScope(
            onDragStarted: onDragStarted,
            onDragEnd: onDragEnd,
            onDragUpdate: onDragUpdate,
            child: Padding(
              padding: vertical4horizontal0,
              child: Builder(
                builder: (context) {
                  viewportContextRef.value = context;
                  return SizedBox(
                    height: UIConstants.vertTabHeight(context),
                    child: Stack(
                      children: [
                        ReorderableListView.builder(
                          scrollController: scrollController,
                          scrollDirection: Axis.horizontal,
                          buildDefaultDragHandles: false,
                          physics: const AlwaysScrollableScrollPhysics(),
                          proxyDecorator: (child, index, animation) {
                            // Override Card theme to make it transparent when dragging
                            return Theme(
                              data: theme.copyWith(
                                cardTheme: theme.cardTheme.copyWith(
                                  color: Colors.transparent,
                                  surfaceTintColor: Colors.transparent,
                                  elevation: 0,
                                ),
                              ),
                              child: child,
                            );
                          },
                          itemCount: tabs.length,
                          onReorder: (oldIndex, newIndex) {
                            context.read<HomeBloc>().add(
                              HomeEvent.onReorderTabs(oldIndex, newIndex),
                            );
                          },
                          itemBuilder: (_, index) {
                            final tab = tabs[index];
                            return Padding(
                              key: ValueKey(tab.id),
                              padding: left4,
                              child: CollectionTab(
                                tab: tab,
                                isEditMode: isEditMode,
                                dragIndex: index,
                              ),
                            );
                          },
                        ),
                        // Transparent overlay so we have a viewport-sized context
                        // for edge-scroll rect; does not block hit testing for drops.
                        const Positioned.fill(
                          child: IgnorePointer(
                            child: SizedBox.expand(),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
          }
          return Padding(
            padding: vertical4horizontal4,
            child: Column(
              children: [
                const _EditModeHelperBanner(isLayoutVertical: true),
                Expanded(
                  child: SizedBox(
                    height: UIConstants.vertTabHeight(context),
                    child: ReorderableListView.builder(
                      scrollController: _scrollController,
                      scrollDirection: Axis.horizontal,
                      buildDefaultDragHandles: false,
                      physics: const AlwaysScrollableScrollPhysics(),
                      proxyDecorator: (child, index, animation) {
                        // Override Card theme to make it transparent when dragging
                        return Theme(
                          data: theme.copyWith(
                            cardTheme: theme.cardTheme.copyWith(
                              color: Colors.transparent,
                              surfaceTintColor: Colors.transparent,
                              elevation: 0,
                            ),
                          ),
                          child: child,
                        );
                      },
                      itemCount: tabs.length,
                      onReorder: (oldIndex, newIndex) {
                        context.read<HomeBloc>().add(
                          HomeEvent.onReorderTabs(oldIndex, newIndex),
                        );
                      },
                      itemBuilder: (_, index) {
                        final tab = tabs[index];
                        return Padding(
                          key: ValueKey(tab.id),
                          padding: horizontal4,
                          child: CollectionTab(
                            tab: tab,
                            isEditMode: isEditMode,
                            dragIndex: index,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],

            ),
          );
        }

        // Normal mode
        return RefreshIndicator(
          onRefresh: () => _onHomeRefresh(context),
          color: context.theme.appColors.textTertiary,
          backgroundColor: context.theme.appColors.scaffoldBackground,
          // Note: The nested scroll structure (SingleChildScrollView wrapping
          // CustomScrollView) is intentional. RefreshIndicator requires vertical
          // scrolling, but this layout uses horizontal scrolling for tabs.
          // The outer vertical scroll enables pull-to-refresh functionality.
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: UIConstants.vertTabHeight(context),
              child: CustomScrollView(
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                scrollBehavior: CustomScrollBehaviour(),
                slivers: [
                  SliverList.builder(
                    itemCount: tabs.length,
                    itemBuilder: (_, index) {
                      final tab = tabs[index];

                      return Padding(
                        padding: horizontal6,
                        child: CollectionTab(
                          tab: tab,
                          isEditMode: isEditMode,
                        ),
                      );
                    },
                  ),
                  const SliverPadding(
                    padding: horizontal6,
                    sliver: SliverToBoxAdapter(
                      child: NewTab(),
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
