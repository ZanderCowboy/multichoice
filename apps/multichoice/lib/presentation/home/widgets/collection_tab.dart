part of '../home_page.dart';

class CollectionTab extends HookWidget {
  const CollectionTab({
    required this.tab,
    this.isEditMode = false,
    this.dragIndex,
    super.key,
  });

  final TabsDTO tab;
  final bool isEditMode;
  final int? dragIndex;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEditMode
          ? null
          : () async {
              await context.router.push(
                DetailsPageRoute(
                  result: SearchResult(isTab: true, item: tab, matchScore: 0),
                  onBack: () {
                    context.read<HomeBloc>().add(const HomeEvent.refresh());
                    context.router.pop();
                  },
                ),
              );
            },
      onLongPress: () async {
        final bloc = context.read<HomeBloc>();
        if (!bloc.state.isEditMode) {
          await HapticFeedback.mediumImpact();
          bloc.add(const HomeEvent.onToggleEditMode());
        }
      },
      child: TabLayout(
        tab: tab,
        isEditMode: isEditMode,
        dragIndex: dragIndex,
      ),
    );
  }
}
