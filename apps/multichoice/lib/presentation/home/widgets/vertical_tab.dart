part of '../home_page.dart';

class _VerticalTab extends StatelessWidget {
  const _VerticalTab({
    required this.tab,
  });

  final TabsDTO tab;

  @override
  Widget build(BuildContext context) {
    final entries = tab.entries;

    return GestureDetector(
      onLongPress: () {
        CustomDialog<AlertDialog>.show(
          context: context,
          title: Text('Delete ${tab.title}?'),
          content: Text(
            "Are you sure you want to delete ${tab.title} and all it's data?",
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                context
                    .read<HomeBloc>()
                    .add(HomeEvent.onLongPressedDeleteTab(tab.id));
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
      child: Card(
        color: Colors.grey[300],
        elevation: 5,
        shadowColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: circularBorder12,
        ),
        child: Padding(
          padding: allPadding6,
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width / 4,
            child: Column(
              children: [
                Text(
                  tab.title,
                  style: const TextStyle(color: Colors.black),
                ),
                Text(tab.subtitle),
                const Divider(
                  height: 20,
                  thickness: 2,
                  color: Colors.black,
                ),
                gap10,
                _Cards(id: tab.id, entries: entries),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
