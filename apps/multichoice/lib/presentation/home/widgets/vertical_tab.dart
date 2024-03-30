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
      child: Card(
        color: context.theme.appColors.primary,
        child: Padding(
          padding: allPadding2,
          child: SizedBox(
            width: UIConstants.tabWidth(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: left4,
                        child: Text(
                          tab.title,
                          style: context.theme.appTextTheme.titleMedium,
                        ),
                      ),
                    ),
                    _MenuWidget(tab: tab),
                  ],
                ),
                if (tab.subtitle.isEmpty)
                  const SizedBox.shrink()
                else
                  Padding(
                    padding: left4,
                    child: Text(
                      tab.subtitle,
                      style: context.theme.appTextTheme.subtitleMedium,
                    ),
                  ),
                Divider(
                  color: context.theme.appColors.secondaryLight,
                  thickness: 2,
                  indent: 4,
                  endIndent: 4,
                ),
                gap4,
                _Cards(id: tab.id, entries: entries),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
