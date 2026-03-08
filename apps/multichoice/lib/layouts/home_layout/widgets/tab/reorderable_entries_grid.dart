part of '../../tab_layout.dart';

class ReorderableEntriesGrid extends StatelessWidget {
  const ReorderableEntriesGrid({
    required this.entries,
    required this.tabId,
    required this.isLayoutVertical,
    required this.isEditMode,
    this.dragIndex,
    super.key,
  });

  final List<EntryDTO> entries;
  final int tabId;
  final bool isLayoutVertical;
  final bool isEditMode;
  final int? dragIndex;

  @override
  Widget build(BuildContext context) {
    return SliverReorderableGrid(
      scrollDirection: Axis.horizontal,
      autoScroll: false,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return SizedBox(
          key: ValueKey(entry.id),
          width: UIConstants.horiTabHeight(context) / 2,
          child: EntryCard(
            entry: entry,
            onDoubleTap: () {},
            isLayoutVertical: isLayoutVertical,
            isEditMode: isEditMode,
            dragIndex: index,
          ),
        );
      },
      itemCount: entries.length,
      onReorder: (oldIndex, newIndex) {
        context.read<HomeBloc>().add(
          HomeEvent.onReorderEntries(
            tabId,
            oldIndex,
            newIndex,
            isGrid: true,
          ),
        );
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
    );
  }
}
