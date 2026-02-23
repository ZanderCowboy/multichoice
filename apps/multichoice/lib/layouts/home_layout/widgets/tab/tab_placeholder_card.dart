import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:multichoice/presentation/home/home_page.dart';

class TabPlaceholderCard extends StatelessWidget {
  const TabPlaceholderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.3,
      child: EntryCard(
        entry: EntryDTO.empty(),
        onDoubleTap: () {},
      ),
    );
  }
}
