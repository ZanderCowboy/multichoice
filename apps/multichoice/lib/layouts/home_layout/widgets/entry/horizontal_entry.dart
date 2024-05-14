part of '../../card_layout.dart';

class _HorizontalEntry extends StatelessWidget {
  const _HorizontalEntry({
    required this.id,
    required this.entries,
  });

  final int id;
  final List<EntryDTO> entries;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomScrollView(
        scrollDirection: Axis.horizontal,
        controller: ScrollController(),
        scrollBehavior: CustomScrollBehaviour(),
        slivers: [
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
              tabId: id,
            ),
          ),
        ],
      ),
    );
  }
}
