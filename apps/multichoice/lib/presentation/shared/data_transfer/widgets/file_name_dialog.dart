import 'package:flutter/material.dart';

class FileNameDialog extends StatefulWidget {
  const FileNameDialog({super.key});

  @override
  State<FileNameDialog> createState() => _FileNameDialogState();
}

class _FileNameDialogState extends State<FileNameDialog> {
  String? _fileName;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter File Name'),
      content: TextField(
        onChanged: (value) => _fileName = value,
        decoration: const InputDecoration(
          hintText: 'File Name',
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(_fileName ?? 'default'),
          child: const Text('Save Export'),
        ),
      ],
    );
  }
}
