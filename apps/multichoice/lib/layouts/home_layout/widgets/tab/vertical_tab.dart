part of '../../tab_layout.dart';

class _VerticalTab extends StatelessWidget {
  const _VerticalTab({
    required this.tab,
  });

  final TabsDTO tab;

  @override
  Widget build(BuildContext context) {
    final entries = tab.entries;
    final isFirstTab = context.watch<HomeBloc>().state.tabs?.first.id == tab.id;

    return Card(
      margin: allPadding4,
      color: context.theme.appColors.primary,
      child: Padding(
        padding: allPadding2,
        child: SizedBox(
          width: UIConstants.vertTabWidth(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: left4,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            tab.title,
                            style: context.theme.appTextTheme.titleMedium,
                          ),
                        ),
                        if (isFirstTab)
                          TourWidgetWrapper(
                            step: ProductTourStep.showCollectionMenu,
                            child: MenuWidget(tab: tab),
                          )
                        else
                          MenuWidget(tab: tab),
                      ],
                    ),
                    if (tab.subtitle.isNotEmpty)
                      Text(
                        tab.subtitle,
                        style: context.theme.appTextTheme.subtitleMedium,
                      )
                    else
                      const SizedBox.shrink(),
                  ],
                ),
              ),
              Divider(
                color: context.theme.appColors.secondaryLight,
                thickness: 2,
                indent: 4,
                endIndent: 4,
              ),
              gap4,
              Items(id: tab.id, entries: entries),
            ],
          ),
        ),
      ),
    );
  }
}
