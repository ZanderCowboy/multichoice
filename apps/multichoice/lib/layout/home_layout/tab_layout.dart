part of 'home_layout.dart';

class TabLayout extends StatelessWidget {
  const TabLayout({
    required this.tab,
    super.key,
  });

  final TabsDTO tab;

  @override
  Widget build(BuildContext context) {
    return context.watch<AppLayout>().appLayout
        ? _VerticalTab(tab: tab)
        : _HorizontalTab(tab: tab);
  }
}

class TabLay {
  TabLay();

  static VertTab vert(TabsDTO tab) => VertTab(tab: tab);

  static HorizontalTab hori(TabsDTO tab) => HorizontalTab(tab: tab);
}

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

class HorizontalTab extends StatelessWidget {
  const HorizontalTab({
    required this.tab,
    super.key,
  });

  final TabsDTO tab;

  @override
  Widget build(BuildContext context) {
    return _HorizontalTab(tab: tab);
  }
}

class _HorizontalTab extends StatelessWidget {
  const _HorizontalTab({
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
          width: UIConstants.horiTabWidth(context),
          height: UIConstants.horiTabHeight(context),
          child: Expanded(
            child: CustomScrollView(
              scrollDirection: Axis.horizontal,
              controller: ScrollController(),
              scrollBehavior: CustomScrollBehaviour(),
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(
                    width: UIConstants.horiTabHeaderWidth(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: left4,
                          child: Text(
                            tab.title,
                            style: context.theme.appTextTheme.titleMedium,
                          ),
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
                        const Expanded(child: SizedBox()),
                        MenuWidget(tab: tab),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: VerticalDivider(
                    color: context.theme.appColors.secondaryLight,
                    thickness: 2,
                    indent: 4,
                    endIndent: 4,
                  ),
                ),
                SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final entry = entries[index];

                    return EntryCard(entry: entry);
                  },
                ),
                SliverToBoxAdapter(
                  child: NewEntry(
                    tabId: tab.id,
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
