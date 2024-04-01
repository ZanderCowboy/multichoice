part of 'home_layout.dart';

class EntryLayout extends StatelessWidget {
  const EntryLayout({
    required this.id,
    required this.entries,
    super.key,
  });

  final int id;
  final List<EntryDTO> entries;

  @override
  Widget build(BuildContext context) {
    return context.watch<AppLayout>().appLayout
        ? _VerticalEntry(
            id: id,
            entries: entries,
          )
        : _HorizontalEntry(
            id: id,
            entries: entries,
          );
  }
}

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
