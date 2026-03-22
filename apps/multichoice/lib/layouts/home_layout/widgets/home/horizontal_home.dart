part of '../../home_layout.dart';

class _HorizontalHome extends StatefulWidget {
  const _HorizontalHome();

  @override
  State<_HorizontalHome> createState() => _HorizontalHomeState();
}

class _HorizontalHomeState extends State<_HorizontalHome> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
          // Use ReorderableListView for edit mode
          final theme = Theme.of(context);
          return Padding(
            padding: top4,
            child: ReorderableListView.builder(
              scrollController: _scrollController,
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
                  padding: const EdgeInsets.only(bottom: 8, top: 4),
                  child: CollectionTab(
                    tab: tab,
                    isEditMode: isEditMode,
                    dragIndex: index,
                  ),
                );
              },
            ),
          );
        }

        // Normal mode
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
