part of '../../tab_layout.dart';

class _HorizontalTab extends HookWidget {
  const _HorizontalTab({
    required this.tab,
  });

  final TabsDTO tab;

  @override
  Widget build(BuildContext context) {
    final entries = tab.entries;
    final scrollController = useScrollController();
    final previousEntriesLength = useState(entries.length);

    useEffect(
      () {
        if (entries.length > previousEntriesLength.value) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          });
        }
        previousEntriesLength.value = entries.length;
        return null;
      },
      [entries.length],
    );

    return Card(
      margin: allPadding4,
      color: context.theme.appColors.primary,
      child: Padding(
        padding: allPadding2,
        child: SizedBox(
          height: UIConstants.horiTabHeight(context),
          child: CustomScrollView(
            scrollDirection: Axis.horizontal,
            controller: scrollController,
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
                          style:
                              context.theme.appTextTheme.titleMedium?.copyWith(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      if (tab.subtitle.isEmpty)
                        const SizedBox.shrink()
                      else
                        Padding(
                          padding: left4,
                          child: Text(
                            tab.subtitle,
                            style: context.theme.appTextTheme.subtitleMedium
                                ?.copyWith(fontSize: 12),
                          ),
                        ),
                      const Expanded(child: SizedBox()),
                      Center(
                        child: MenuWidget(tab: tab),
                      ),
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
                itemCount: entries.length + 1,
                itemBuilder: (context, index) {
                  if (index == entries.length) {
                    return NewEntry(
                      tabId: tab.id,
                    );
                  }

                  final entry = entries[index];

                  return EntryCard(
                    entry: entry,
                    onDoubleTap: () {
                      context
                          .read<HomeBloc>()
                          .add(HomeEvent.onUpdateEntry(entry.id));
                      context.router.push(EditEntryPageRoute(ctx: context));
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
