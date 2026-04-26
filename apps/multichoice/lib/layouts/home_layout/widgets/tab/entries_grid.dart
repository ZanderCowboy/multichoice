part of '../../tab_layout.dart';

class EntriesGrid extends StatelessWidget {
  const EntriesGrid({
    required this.entries,
    required this.isEditMode,
    required this.isLayoutVertical,
    required this.tabId,
    super.key,
  });

  final List<EntryDTO> entries;
  final int tabId;
  final bool isLayoutVertical;
  final bool isEditMode;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: vertical4,
      sliver: SliverGrid.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: entries.length + 1,
        itemBuilder: (context, index) {
          if (index == entries.length) {
            return NewEntry(
              tabId: tabId,
            );
          }

          final entry = entries[index];

          return EntryCard(
            entry: entry,
            isLayoutVertical: isLayoutVertical,
            isEditMode: isEditMode,
            onDoubleTap: () async {
              context.read<HomeBloc>().add(
                HomeEvent.onUpdateEntry(entry.id),
              );
              await context.router.push(
                EditEntryPageRoute(ctx: context),
              );
            },
          );
        },
      ),
    );
  }
}
