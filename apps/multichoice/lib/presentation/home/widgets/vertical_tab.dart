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
          title: RichText(
            text: TextSpan(
              text: 'Delete ',
              style: DefaultTextStyle.of(context).style.copyWith(fontSize: 24),
              children: [
                TextSpan(
                  text: tab.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '?',
                  style:
                      DefaultTextStyle.of(context).style.copyWith(fontSize: 24),
                ),
              ],
            ),
          ),
          content: Text(
            "Are you sure you want to delete tab ${tab.title} and all it's entries?",
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
      child: Padding(
        padding: right4,
        child: Card(
          color: Colors.grey[200],
          elevation: 5,
          shadowColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: circularBorder12,
          ),
          child: Padding(
            padding: allPadding4,
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width / 4,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: left4,
                          child: Text(
                            tab.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      MenuWidget(tab: tab),
                    ],
                  ),
                  const Divider(
                    indent: 4,
                    endIndent: 4,
                  ),
                  Padding(
                    padding: left4,
                    child: Text(
                      tab.subtitle,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  gap10,
                  _Cards(id: tab.id, entries: entries),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
