import 'package:flutter/material.dart';
import 'package:multichoice/utils/custom_dialog.dart';

void deleteModal({
  required BuildContext context,
  required String title,
  required Widget content,
  required VoidCallback onConfirm,
  String? confirmText,
  VoidCallback? onCancel,
  String? cancelText,
}) {
  CustomDialog<AlertDialog>.show(
    context: context,
    title: RichText(
      text: TextSpan(
        text: 'Delete ',
        style: DefaultTextStyle.of(context).style.copyWith(
              fontSize: 24,
            ),
        children: [
          TextSpan(
            text: title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: '?',
            style: DefaultTextStyle.of(context).style.copyWith(
                  fontSize: 24,
                ),
          ),
        ],
      ),
    ),
    content: content,
    actions: [
      OutlinedButton(
        onPressed: onCancel ?? () => Navigator.of(context).pop(),
        child: const Text('Cancel'),
      ),
      ElevatedButton(
        onPressed: onConfirm,
        child: const Text('Delete'),
      ),
    ],
  );
}
