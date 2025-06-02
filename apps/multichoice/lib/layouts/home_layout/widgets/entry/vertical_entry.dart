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

              if (entries.isNotEmpty && index == 0) {
                return FutureBuilder(
                  future: coreSl<IProductTourController>().currentStep,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.data ==
                          ProductTourStep.showItemsInCollection) {
                        return TourWidgetWrapper(
                          step: ProductTourStep.showItemsInCollection,
                          child: EntryCard(entry: entry),
                        );
                      } else if (snapshot.data ==
                          ProductTourStep.showItemActions) {
                        return TourWidgetWrapper(
                          step: ProductTourStep.showItemActions,
                          child: EntryCard(entry: entry),
                        );
                      }
                    }
                    return EntryCard(entry: entry);
                  },
                );
              }

              return EntryCard(entry: entry);
            },
          ),
          SliverToBoxAdapter(
            child: TourWidgetWrapper(
              step: ProductTourStep.addNewItem,
              tabId: id,
              child: NewEntry(
                tabId: id,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
