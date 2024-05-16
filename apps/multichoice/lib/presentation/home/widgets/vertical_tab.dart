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
      onLongPress: () {
        CustomDialog<AlertDialog>.show(
          context: context,
          title: RichText(
            text: TextSpan(
              text: 'Delete ',
              style: DefaultTextStyle.of(context).style.copyWith(
                    fontSize: 24,
                  ),
              children: [
                TextSpan(
                  text: tab.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '?',
                  style: DefaultTextStyle.of(context).style.copyWith(
                        fontSize: 24,
                      ),
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
      child: TabLayout(tab: tab),
    );
  }
}
