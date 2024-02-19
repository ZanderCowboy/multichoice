import 'package:flutter/material.dart';
import 'package:multichoice/constants/export_constants.dart';

class AddTabCard extends StatelessWidget {
  const AddTabCard({
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
          borderRadius: circularBorder12,
        ),
        child: Padding(
          padding: allPadding6,
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width / 4,
            child: const IconButton(
              iconSize: 36,
              onPressed: null,
              icon: Icon(Icons.add_outlined),
            ),
          ),
        ),
      ),
    );
  }
}
