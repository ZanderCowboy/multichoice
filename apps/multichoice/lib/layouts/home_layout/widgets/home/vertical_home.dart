part of '../../home_layout.dart';

class _VerticalHome extends StatelessWidget {
  const _VerticalHome({
    required this.tabs,
  });

  final List<TabsDTO> tabs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: left0top4right0bottom24,
      child: SizedBox(
        height: UIConstants.vertTabHeight(context),
        child: CustomScrollView(
          scrollDirection: Axis.horizontal,
          controller: ScrollController(),
          scrollBehavior: CustomScrollBehaviour(),
          slivers: [
            SliverPadding(
              padding: left4,
              sliver: SliverList.builder(
                itemCount: tabs.length,
                itemBuilder: (_, index) {
                  final tab = tabs[index];

                  if (tabs.isNotEmpty && index == 0) {
                    return FutureBuilder(
                      future: coreSl<IProductTourController>().currentStep,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.data == ProductTourStep.showCollection) {
                            return TourWidgetWrapper(
                              step: ProductTourStep.showCollection,
                              child: CollectionTab(tab: tab),
                            );
                          } else if (snapshot.data ==
                              ProductTourStep.showCollectionActions) {
                            return TourWidgetWrapper(
                              step: ProductTourStep.showCollectionActions,
                              child: CollectionTab(tab: tab),
                            );
                          }
                        }
                        return CollectionTab(tab: tab);
                      },
                    );
                  }

                  return CollectionTab(tab: tab);
                },
              ),
            ),
            const SliverPadding(
              padding: right12,
              sliver: SliverToBoxAdapter(
                child: TourWidgetWrapper(
                  step: ProductTourStep.addNewCollection,
                  child: NewTab(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
