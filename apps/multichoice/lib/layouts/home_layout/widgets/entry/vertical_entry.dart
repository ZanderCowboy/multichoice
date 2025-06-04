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
                final step = context.watch<ProductBloc>().state.currentStep;

                if (step == ProductTourStep.showItemsInCollection) {
                  return TourWidgetWrapper(
                    step: ProductTourStep.showItemsInCollection,
                    child: EntryCard(entry: entry),
                  );
                } else if (step == ProductTourStep.showItemActions) {
                  return TourWidgetWrapper(
                    step: ProductTourStep.showItemActions,
                    child: EntryCard(entry: entry),
                  );
                }

                return EntryCard(entry: entry);
              }

              return EntryCard(entry: entry);
            },
          ),
          SliverToBoxAdapter(
            child: TourWidgetWrapper(
              step: ProductTourStep.addNewItem,
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
