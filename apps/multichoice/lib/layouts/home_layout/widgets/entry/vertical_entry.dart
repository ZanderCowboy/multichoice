part of '../../card_layout.dart';

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
