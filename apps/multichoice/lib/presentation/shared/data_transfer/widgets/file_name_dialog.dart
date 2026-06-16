import 'package:flutter/material.dart';
import 'package:multichoice/i18n/strings.g.dart';

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
      title: Text(context.t.dataTransfer.enterFileName),
      content: TextField(
        onChanged: (value) => _fileName = value,
        decoration: InputDecoration(
          hintText: context.t.dataTransfer.fileNameHint,
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.t.common.cancel),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(_fileName ?? 'default'),
          child: Text(context.t.dataTransfer.saveExport),
        ),
      ],
    );
  }
}
