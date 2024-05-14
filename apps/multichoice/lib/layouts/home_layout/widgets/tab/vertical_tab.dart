part of '../../tab_layout.dart';

class VertTab extends StatelessWidget {
  const VertTab({
    required this.tab,
    super.key,
  });

  final TabsDTO tab;

  @override
  Widget build(BuildContext context) {
    return _VerticalTab(tab: tab);
  }
}

class _VerticalTab extends StatelessWidget {
  const _VerticalTab({
    required this.tab,
  });

  final TabsDTO tab;

  @override
  Widget build(BuildContext context) {
    final entries = tab.entries;
    return Card(
      color: context.theme.appColors.primary,
      child: Padding(
        padding: allPadding2,
        child: SizedBox(
          width: UIConstants.vertTabWidth(context),
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
                  MenuWidget(tab: tab),
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
              Cards(id: tab.id, entries: entries),
            ],
          ),
        ),
      ),
    );
  }
}
