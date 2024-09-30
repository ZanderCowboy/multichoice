import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/engine/app_router.gr.dart';
import 'package:multichoice/app/view/layout/app_layout.dart';
import 'package:multichoice/presentation/home/home_page.dart';
import 'package:multichoice/utils/custom_scroll_behaviour.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

part 'widgets/entry/_horizontal_entry.dart';
part 'widgets/entry/_vertical_entry.dart';

class EntryLayout extends StatelessWidget {
  const EntryLayout({
    required this.id,
    required this.entries,
    super.key,
  });

  final int id;
  final List<EntryDTO> entries;

  @override
  Widget build(BuildContext context) {
    return context.watch<AppLayout>().appLayout
        ? _VerticalEntry(
            id: id,
            entries: entries,
          )
        : _HorizontalEntry(
            id: id,
            entries: entries,
          );
  }
}
