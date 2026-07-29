import 'package:flutter/material.dart';
import 'package:multichoice/i18n/strings.g.dart';

class ImportConfirmationDialog extends StatelessWidget {
  const ImportConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.t.common.warning),
      content: Text(
        context.t.dataTransfer.importConfirmationBody,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.t.common.cancel),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(context.t.common.overwrite),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(context.t.common.append),
        ),
      ],
    );
  }
}
