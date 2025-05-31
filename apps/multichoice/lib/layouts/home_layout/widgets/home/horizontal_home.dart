part of '../../home_layout.dart';

class _HorizontalHome extends StatelessWidget {
  const _HorizontalHome({
    required this.tabs,
  });

  final List<TabsDTO> tabs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: horizontal8,
      child: CustomScrollView(
        controller: ScrollController(),
        scrollBehavior: CustomScrollBehaviour(),
        slivers: [
          SliverPadding(
            padding: top4,
            sliver: SliverList.builder(
              itemCount: tabs.length,
              itemBuilder: (_, index) {
                final tab = tabs[index];

                return TourCollectionTab(tab: tab);
              },
            ),
          ),
          const SliverPadding(
            padding: bottom24,
            sliver: SliverToBoxAdapter(
              child: NewTab(),
            ),
          ),
        ],
      ),
    );
  }
}
