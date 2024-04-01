import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/extensions/extension_getters.dart';
import 'package:multichoice/app/view/theme/theme_extension/app_theme_extension.dart';
import 'package:multichoice/constants/export_constants.dart';
import 'package:multichoice/layout/app_layout.dart';
import 'package:multichoice/presentation/home/home_page.dart';
import 'package:multichoice/utils/custom_scroll_behaviour.dart';
import 'package:provider/provider.dart';

part 'tab_layout.dart';
part 'card_layout.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({
    required this.tabs,
    super.key,
  });

  final List<TabsDTO> tabs;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: context.watch<AppLayout>().appLayout
          ? _VerticalHome(tabs: tabs)
          : _HorizontalHome(tabs: tabs),
    );
  }
}

class _VerticalHome extends StatelessWidget {
  const _VerticalHome({
    required this.tabs,
  });

  final List<TabsDTO> tabs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: vertical12,
      child: SizedBox(
        height: UIConstants.vertTabHeight(context),
        child: CustomScrollView(
          scrollDirection: Axis.horizontal,
          controller: ScrollController(),
          scrollBehavior: CustomScrollBehaviour(),
          slivers: [
            SliverPadding(
              padding: left12,
              sliver: SliverList.builder(
                itemCount: tabs.length,
                itemBuilder: (_, index) {
                  final tab = tabs[index];

                  return VerticalTab(tab: tab);
                },
              ),
            ),
            const SliverPadding(
              padding: right12,
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
