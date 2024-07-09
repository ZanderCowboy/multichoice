import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/extensions/extension_getters.dart';
import 'package:multichoice/app/view/layout/app_layout.dart';
import 'package:multichoice/app/view/theme/theme_extension/app_theme_extension.dart';
import 'package:multichoice/constants/export_constants.dart';
import 'package:multichoice/presentation/home/home_page.dart';
import 'package:multichoice/utils/custom_scroll_behaviour.dart';
import 'package:provider/provider.dart';

part 'widgets/tab/horizontal_tab.dart';
part 'widgets/tab/vertical_tab.dart';

class TabLayout extends StatelessWidget {
  const TabLayout({
    required this.tab,
    super.key,
  });

  final TabsDTO tab;

  @override
  Widget build(BuildContext context) {
    return context.watch<AppLayout>().appLayout
        ? _VerticalTab(tab: tab)
        : _HorizontalTab(tab: tab);
  }
}

class TabLay {
  TabLay();

  static VertTab vert(TabsDTO tab) => VertTab(tab: tab);

  static HorizontalTab hori(TabsDTO tab) => HorizontalTab(tab: tab);
}
