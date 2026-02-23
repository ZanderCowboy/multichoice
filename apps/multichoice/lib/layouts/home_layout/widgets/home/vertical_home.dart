part of '../../home_layout.dart';

/// Width of the edge zone (in logical pixels). When the drag is in this zone
/// near the left or right edge, the list scrolls.
const _kEdgeScrollZoneWidth = 80.0;

/// Scroll distance per tick while in the edge zone.
const _kEdgeScrollStep = 12.0;

/// Interval between scroll ticks while hovering in the edge zone.
const _kEdgeScrollInterval = Duration(milliseconds: 50);

class _VerticalHome extends HookWidget {
  const _VerticalHome();

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final dragPositionRef = useRef<Offset?>(null);
    final isDraggingRef = useRef(false);
    final viewportContextRef = useRef<BuildContext?>(null);

    useEffect(
      () {
        final timer = Timer.periodic(_kEdgeScrollInterval, (_) {
          if (!isDraggingRef.value) return;
          final pos = dragPositionRef.value;
          if (pos == null) return;
          final ctx = viewportContextRef.value;
          if (ctx == null || !ctx.mounted) return;
          final box = ctx.findRenderObject() as RenderBox?;
          if (box == null || !box.hasSize) return;
          final viewportRect =
              box.localToGlobal(Offset.zero) & box.size;
          final position = scrollController.position;
          if (pos.dx < viewportRect.left + _kEdgeScrollZoneWidth) {
            final newOffset =
                (position.pixels - _kEdgeScrollStep)
                    .clamp(position.minScrollExtent, position.maxScrollExtent);
            scrollController.jumpTo(newOffset);
          } else if (pos.dx > viewportRect.right - _kEdgeScrollZoneWidth) {
            final newOffset =
                (position.pixels + _kEdgeScrollStep)
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
          // Use ReorderableListView with horizontal scrolling for edit mode.
          // Wrap in DragScrollScope and overlay so dragging near edges scrolls.
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
            ),
          );
        }

        // Normal mode
        // Note: The nested scroll structure (SingleChildScrollView wrapping
        // CustomScrollView) is intentional. RefreshIndicator requires vertical
        // scrolling, but this layout uses horizontal scrolling for tabs.
        // The outer vertical scroll enables pull-to-refresh functionality.
        return RefreshIndicator(
          onRefresh: () => _onHomeRefresh(context),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: vertical4horizontal0,
              child: SizedBox(
                height: UIConstants.vertTabHeight(context),
                child: CustomScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: scrollController,
                  scrollBehavior: CustomScrollBehaviour(),
                  slivers: [
                    SliverPadding(
                      padding: left4,
                      sliver: SliverList.builder(
                        itemCount: tabs.length,
                        itemBuilder: (_, index) {
                          final tab = tabs[index];

                          return CollectionTab(
                            tab: tab,
                            isEditMode: isEditMode,
                          );
                        },
                      ),
                    ),
                    const SliverPadding(
                      padding: right12,
                      sliver: SliverToBoxAdapter(
                        child: NewTab(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
