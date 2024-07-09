part of '../home_page.dart';

class VerticalTab extends StatelessWidget {
  const VerticalTab({
    required this.tab,
    super.key,
  });

  final TabsDTO tab;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _onDeleteTab(context),
      child: TabLayout(tab: tab),
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
