import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/presentation/home/home_page.dart';
import 'package:ui_kit/ui_kit.dart';

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
    return context.watch<AppLayout>().isLayoutVertical
        ? _VerticalTab(tab: tab)
        : _HorizontalTab(tab: tab);
  }
}
