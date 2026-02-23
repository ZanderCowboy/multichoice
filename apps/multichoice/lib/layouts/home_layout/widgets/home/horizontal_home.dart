part of '../../home_layout.dart';

/// Width of the edge zone for horizontal layout (top/bottom). When the drag
/// is in this zone, the collections list scrolls vertically.
const _kHorizontalEdgeScrollZoneWidth = 80.0;

/// Scroll step and interval (same as vertical layout).
const _kHorizontalEdgeScrollStep = 12.0;
const _kHorizontalEdgeScrollInterval = Duration(milliseconds: 50);

class _HorizontalHome extends HookWidget {
  const _HorizontalHome();

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final dragPositionRef = useRef<Offset?>(null);
    final isDraggingRef = useRef(false);
    final viewportContextRef = useRef<BuildContext?>(null);

    useEffect(
      () {
        final timer = Timer.periodic(_kHorizontalEdgeScrollInterval, (_) {
          if (!isDraggingRef.value) return;
          final pos = dragPositionRef.value;
          if (pos == null) return;
          final ctx = viewportContextRef.value;
          if (ctx == null || !ctx.mounted) return;
          final box = ctx.findRenderObject() as RenderBox?;
          if (box == null || !box.hasSize) return;
          final viewportRect = box.localToGlobal(Offset.zero) & box.size;
          final position = scrollController.position;
          // Top edge: scroll up (decrease pixels).
          if (pos.dy < viewportRect.top + _kHorizontalEdgeScrollZoneWidth) {
            final newOffset = (position.pixels - _kHorizontalEdgeScrollStep)
                .clamp(position.minScrollExtent, position.maxScrollExtent);
            scrollController.jumpTo(newOffset);
          } else if (pos.dy >
              viewportRect.bottom - _kHorizontalEdgeScrollZoneWidth) {
            final newOffset = (position.pixels + _kHorizontalEdgeScrollStep)
                .clamp(position.minScrollExtent, position.maxScrollExtent);
            scrollController.jumpTo(newOffset);
          }
        });
        return timer.cancel;
      },
      [scrollController],
    );

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
            await scrollController.animateTo(
              scrollController.position.maxScrollExtent,
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
          // Use ReorderableListView for edit mode. Wrap in DragScrollScope
          // and overlay so dragging near top/bottom scrolls the collections list.
          final theme = Theme.of(context);
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
              padding: horizontal8,
              child: Builder(
                builder: (context) {
                  viewportContextRef.value = context;
                  return Stack(
                    children: [
                      ReorderableListView.builder(
                        scrollController: scrollController,
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
                            padding: top4,
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
                  );
                },
              ),
            ),
          );
        }

        // Normal mode
        return RefreshIndicator(
          onRefresh: () => _onHomeRefresh(context),
          child: Padding(
            padding: horizontal8,
            child: CustomScrollView(
              controller: scrollController,
              scrollBehavior: CustomScrollBehaviour(),
              slivers: [
                SliverPadding(
                  padding: top4,
                  sliver: SliverList.builder(
                    itemCount: tabs.length,
                    itemBuilder: (_, index) {
                      final tab = tabs[index];

                      return CollectionTab(tab: tab, isEditMode: isEditMode);
                    },
                  ),
                ),
                const SliverPadding(
                  padding: bottom24,
                  sliver: SliverToBoxAdapter(
                    child: NewTab(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
