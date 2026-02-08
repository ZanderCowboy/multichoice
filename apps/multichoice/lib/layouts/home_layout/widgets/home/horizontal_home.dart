part of '../../home_layout.dart';

class _HorizontalHome extends HookWidget {
  const _HorizontalHome();

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();

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
          // Use ReorderableListView for edit mode
          return Padding(
            padding: horizontal8,
            child: ReorderableListView.builder(
              scrollController: scrollController,
              buildDefaultDragHandles: false,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: tabs.length,
              onReorder: (oldIndex, newIndex) {
                context.read<HomeBloc>().add(
                  HomeEvent.onReorderTabs(oldIndex, newIndex),
                );
              },
              itemBuilder: (_, index) {
                final tab = tabs[index];
                return ReorderableDragStartListener(
                  key: ValueKey(tab.id),
                  index: index,
                  child: Padding(
                    padding: top4,
                    child: CollectionTab(tab: tab, isEditMode: isEditMode),
                  ),
                );
              },
            ),
          );
        }

        // Normal mode
        return Padding(
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
        );
      },
    );
  }
}
