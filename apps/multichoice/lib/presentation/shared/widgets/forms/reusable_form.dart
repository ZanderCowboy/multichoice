// ignore_for_file: avoid_catches_without_on_clauses, document_ignores

import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class ReusableForm extends StatelessWidget {
  const ReusableForm({
    required this.titleController,
    required this.subtitleController,
    required this.onTitleChanged,
    required this.onSubtitleChanged,
    required this.onCancel,
    required this.onAdd,
    required this.isValid,
    super.key,
    this.onTitleTap,
    this.onSubtitleTap,
  });

  final TextEditingController titleController;
  final TextEditingController subtitleController;
  final void Function(String) onTitleChanged;
  final void Function(String) onSubtitleChanged;
  final VoidCallback onCancel;
  final VoidCallback onAdd;
  final bool isValid;
  final VoidCallback? onTitleTap;
  final VoidCallback? onSubtitleTap;

  bool _isControllerValid(TextEditingController controller) {
    try {
      // Try to add and remove a listener to check if controller is disposed
      // This will throw if the controller is disposed
      void listener() {}

      controller
        ..addListener(listener)
        ..removeListener(listener);

      return true;
    } catch (e) {
      // Controller is disposed or invalid
      return false;
    }
  }

  String _safeGetText(TextEditingController controller) {
    try {
      return controller.text;
    } catch (e) {
      // Controller is disposed, return empty string
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if controllers are still valid before using them
    final areControllersValid =
        _isControllerValid(titleController) &&
        _isControllerValid(subtitleController);

    if (!areControllersValid) {
      // Return empty container if controllers are disposed
      // This prevents errors during widget rebuilds
      return const SizedBox.shrink();
    }

    // Safely get title text to avoid disposed controller errors
    final titleText = _safeGetText(titleController);
    final isTitleNotEmpty = titleText.isNotEmpty;

    return Form(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: titleController,
              onChanged: onTitleChanged,
              onTap: onTitleTap,
              decoration: const InputDecoration(
                labelText: 'Enter a Title',
                hintText: 'Title',
              ),
            ),
            gap10,
            TextFormField(
              controller: subtitleController,
              onChanged: onSubtitleChanged,
              onTap: onSubtitleTap,
              decoration: const InputDecoration(
                labelText: 'Enter a Subtitle',
                hintText: 'Subtitle',
              ),
            ),
            gap24,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: onCancel,
                  child: const Text('Cancel'),
                ),
                gap4,
                ElevatedButton(
                  onPressed: isValid && isTitleNotEmpty ? onAdd : null,
                  child: const Text('Add'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
