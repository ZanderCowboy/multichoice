part of '../../home_layout.dart';

class _HorizontalHome extends StatelessWidget {
  const _HorizontalHome({
    required this.tabs,
  });

  final List<TabsDTO> tabs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: horizontal12,
      child: SizedBox(
        width: UIConstants.horiTabWidth(context),
        child: CustomScrollView(
          controller: ScrollController(),
          scrollBehavior: CustomScrollBehaviour(),
          slivers: [
            SliverPadding(
              padding: top12,
              sliver: SliverList.builder(
                itemCount: tabs.length,
                itemBuilder: (_, index) {
                  final tab = tabs[index];

                  return VerticalTab(tab: tab);
                },
              ),
            ),
            const SliverPadding(
              padding: bottom12,
              sliver: SliverToBoxAdapter(
                child: NewTab(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
