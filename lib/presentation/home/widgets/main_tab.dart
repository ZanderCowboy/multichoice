part of '../home_page.dart';

class VerticalTab extends StatelessWidget {
  const VerticalTab({
    required this.title,
    required this.subtitle,
    super.key,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return GestureDetector(
      onLongPress: () {
        CustomDialog.show(
          context: context,
          title: const Text('delete'),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                gap10,
                ElevatedButton(
                  onPressed: () {
                    context
                        .read<HomeBloc>()
                        .add(const HomeEvent.onLongPressedDeleteTab());
                    Navigator.of(context).pop();
                  },
                  child: const Text('Delete'),
                ),
              ],
            )
          ],
        );
      },
      child: Card(
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
                Row(
                  children: [
                    Expanded(child: Text(title)),
                    const IconButton(
                      onPressed: null,
                      icon: Icon(Icons.add_outlined),
                    ),
                  ],
                ),
                gap10,
                Expanded(
                  child: ScrollConfiguration(
                    behavior: CustomScrollBehaviour(),
                    child: ListView(
                      controller: scrollController,
                      children: const [
                        EntryCard(),
                        gap16,
                        EntryCard(),
                        gap16,
                        EntryCard(),
                        gap16,
                        EntryCard(),
                        gap16,
                        EntryCard(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
