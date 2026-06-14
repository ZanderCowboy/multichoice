import 'package:flutter/material.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/i18n/strings.g.dart';
import 'package:ui_kit/ui_kit.dart';

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
    title: Text.rich(
      key: context.keys.deleteModalTitle,
      context.t.modals.deleteItemTitle(
        item: TextSpan(
          text: title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      style: DefaultTextStyle.of(context).style.copyWith(
        fontSize: 24,
      ),
    ),
    content: content,
    actions: [
      OutlinedButton(
        onPressed: onCancel ?? () => Navigator.of(context).pop(),
        child: Text(cancelText ?? context.t.common.cancel),
      ),
      ElevatedButton(
        onPressed: onConfirm,
        child: Text(confirmText ?? context.t.common.delete),
      ),
    ],
  );
}
