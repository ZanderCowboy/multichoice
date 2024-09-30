import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/view/layout/app_layout.dart';
import 'package:multichoice/constants/export_constants.dart';
import 'package:multichoice/presentation/home/home_page.dart';
import 'package:multichoice/utils/custom_scroll_behaviour.dart';
import 'package:provider/provider.dart';

part 'widgets/home/_horizontal_home.dart';
part 'widgets/home/_vertical_home.dart';

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
