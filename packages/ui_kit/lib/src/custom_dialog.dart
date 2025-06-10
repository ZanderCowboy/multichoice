import 'package:flutter/material.dart';

class CustomDialog<T> {
  CustomDialog.show({
    required this.context,
    this.title,
    this.actions,
    this.content,
  }) {
    showDialog<T>(
      context: context,
      builder: _buildWidget,
    );
  }

  final BuildContext context;
  final Widget? title;
  final Widget? content;
  final List<Widget>? actions;

  Widget _buildWidget(BuildContext context) {
    return AlertDialog(
      title: title,
      content: content,
      actions: actions,
    );
  }
}
