part of '../../home_layout.dart';

class _HorizontalHome extends StatefulWidget {
  const _HorizontalHome();

  @override
  State<_HorizontalHome> createState() => _HorizontalHomeState();
}

class _HorizontalHomeState extends State<_HorizontalHome> {
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

    if (pos.dy < viewportRect.top + zone) {
      final newOffset = (position.pixels - step).clamp(
        position.minScrollExtent,
        position.maxScrollExtent,
      );
      _scrollController.jumpTo(newOffset);
    } else if (pos.dy > viewportRect.bottom - zone) {
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
        if (previous.tabs == null || current.tabs == null) return false;

        final oldLength = previous.tabs!.length;
        final newLength = current.tabs!.length;
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
          final theme = Theme.of(context);

          return Column(
            children: [
              const _EditModeHelperBanner(isLayoutVertical: false),
              Expanded(
                child: Padding(
                  padding: top4,
                  child: DragScrollScope(
                    onDragStarted: () => setState(() => _isDragging = true),
                    onDragEnd: () => setState(() {
                      _isDragging = false;
                      _dragPosition = null;
                    }),
                    onDragUpdate: (globalPosition) {
                      _dragPosition = globalPosition;
                    },
                    child: KeyedSubtree(
                      key: _viewportKey,
                      child: Stack(
                        children: [
                          ReorderableListView.builder(
                            scrollController: _scrollController,
                            buildDefaultDragHandles: false,
                            physics: const AlwaysScrollableScrollPhysics(),
                            proxyDecorator: (child, index, animation) {
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
                                padding: const EdgeInsets.only(
                                  bottom: 8,
                                  top: 4,
                                ),
                                child: CollectionTab(
                                  tab: tab,
                                  isEditMode: isEditMode,
                                  dragIndex: index,
                                ),
                              );
                            },
                          ),
                          const Positioned.fill(
                            child: IgnorePointer(
                              child: SizedBox.expand(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        return RefreshIndicator(
          onRefresh: () => _onHomeRefresh(context),
          color: context.theme.appColors.textTertiary,
          backgroundColor: context.theme.appColors.scaffoldBackground,
          child: CustomScrollView(
            controller: _scrollController,
            scrollBehavior: CustomScrollBehaviour(),
            slivers: [
              SliverPadding(
                padding: top4,
                sliver: SliverList.builder(
                  itemCount: tabs.length,
                  itemBuilder: (_, index) {
                    final tab = tabs[index];

                    return Padding(
                      padding: vertical6,
                      child: CollectionTab(
                        tab: tab,
                        isEditMode: isEditMode,
                      ),
                    );
                  },
                ),
              ),
              SliverPadding(
                padding: horizontal12 + bottom24,
                sliver: const SliverToBoxAdapter(
                  child: NewTab(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
