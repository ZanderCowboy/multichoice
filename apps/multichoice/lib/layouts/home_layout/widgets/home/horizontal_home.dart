part of '../../home_layout.dart';

class _HorizontalHome extends HookWidget {
  const _HorizontalHome();

  @override
  Widget build(BuildContext context) {
    final scrollController = useMemoized(ScrollController.new, const []);

    return BlocConsumer<HomeBloc, HomeState>(
      listenWhen: (previous, current) {
        final oldLength = previous.tabs?.length ?? 0;
        final newLength = current.tabs?.length ?? 0;
        final isLoading = !previous.isLoading || current.isLoading;

        /// Only scroll if the number of tabs has increased
        return oldLength < newLength && !isLoading && previous.tabs != null;
      },
      listener: (context, state) {
        if (state.tabs != null && state.tabs!.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          });
        }
      },
      builder: (context, state) {
        final tabs = state.tabs ?? [];

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

                    return CollectionTab(tab: tab);
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
