import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/view/layout/app_layout.dart';
import 'package:multichoice/presentation/home/home_page.dart';

class TabPlaceholderCard extends StatelessWidget {
  const TabPlaceholderCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isLayoutVertical = context.watch<AppLayout>().isLayoutVertical;

    return Opacity(
      opacity: 0.3,
      child: EntryCard(
        entry: EntryDTO.empty(),
        onDoubleTap: () {},
        isLayoutVertical: isLayoutVertical,
      ),
    );
  }
}
