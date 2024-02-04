import 'package:flutter/material.dart';
import 'package:multichoice/constants/export_constants.dart';

class AddEntryCard extends StatelessWidget {
  const AddEntryCard({
    this.semanticLabel,
    super.key,
  });

  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      child: Card(
        elevation: 5,
        color: Colors.grey[600],
        shape: RoundedRectangleBorder(
          borderRadius: circularBorder5,
        ),
        child: const Padding(
          padding: allPadding6,
          child: IconButton(
            iconSize: 36,
            onPressed: null,
            icon: Icon(
              Icons.add_outlined,
            ),
          ),
        ),
      ),
    );
  }
}
