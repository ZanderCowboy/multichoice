part of '../../entry_layout.dart';

class _VerticalEntry extends StatelessWidget {
  const _VerticalEntry({
    required this.id,
    required this.entries,
  });

  final int id;
  final List<EntryDTO> entries;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomScrollView(
        controller: ScrollController(),
        scrollBehavior: CustomScrollBehaviour(),
        slivers: [
          SliverList.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];

              return Showcase(
                key: coreSl<ShowcaseManager>().entryMenu,
                title: 'Entry Menu',
                description:
                    'This is your entries. Single tap to view the entry, double tap to edit the entry, and long press to open the menu',
                disposeOnTap: true,
                onTargetClick: () {
                  context
                      .read<HomeBloc>()
                      .add(HomeEvent.onUpdateEntry(entry.id));
                  context.router.push(EditEntryPageRoute(ctx: context));
                  // coreSl<ShowcaseManager>().startBackButtonShowcase(context);
                },
                onTargetLongPress: () {},
                child: EntryCard(entry: entry),
              );
            },
          ),
          SliverToBoxAdapter(
            child: NewEntry(
              tabId: id,
            ),
          ),
        ],
      ),
    );
  }
}
