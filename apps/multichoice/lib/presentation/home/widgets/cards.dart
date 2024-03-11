part of '../home_page.dart';

class _Cards extends StatelessWidget {
  const _Cards({
    required this.id,
    required this.entries,
  });

  final int id;
  final List<EntryDTO> entries;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Expanded(
          child: CustomScrollView(
            controller: ScrollController(),
            scrollBehavior: CustomScrollBehaviour(),
            slivers: [
              SliverList.builder(
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final entry = entries[index];

                  return _EntryCard(entry: entry);
                },
              ),
              SliverToBoxAdapter(
                child: _NewEntry(
                  tabId: id,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
