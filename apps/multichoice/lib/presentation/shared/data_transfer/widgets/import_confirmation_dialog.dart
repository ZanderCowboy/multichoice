import 'package:flutter/material.dart';

class ImportConfirmationDialog extends StatelessWidget {
  const ImportConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Warning!'),
      content: const Text(
        'Importing data will alter existing data. Do you want to overwrite or append?',
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Overwrite'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Append'),
        ),
      ],
    );
  }
}
