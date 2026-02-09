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
      onLongPress: isEditMode ? null : () => _onDeleteTab(context),
      child: TabLayout(
        tab: tab,
        isEditMode: isEditMode,
        dragIndex: dragIndex,
      ),
    );
  }

  void _onDeleteTab(BuildContext context) {
    deleteModal(
      context: context,
      title: tab.title,
      content: Text(
        "Are you sure you want to delete tab ${tab.title} and all it's entries?",
      ),
      onConfirm: () {
        context.read<HomeBloc>().add(HomeEvent.onLongPressedDeleteTab(tab.id));
        Navigator.of(context).pop();
      },
    );
  }
}
