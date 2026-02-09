part of '../../home_layout.dart';

class _VerticalHome extends HookWidget {
  const _VerticalHome();

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

        // Note: The nested scroll structure (SingleChildScrollView wrapping
        // CustomScrollView) is intentional. RefreshIndicator requires vertical
        // scrolling, but this layout uses horizontal scrolling for tabs.
        // The outer vertical scroll enables pull-to-refresh functionality.
        return RefreshIndicator(
          onRefresh: () => context.performHomeRefresh(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: left0top4right0bottom24,
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

                          return CollectionTab(tab: tab);
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
