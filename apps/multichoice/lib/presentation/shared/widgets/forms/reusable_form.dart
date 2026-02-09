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

  @override
  Widget build(BuildContext context) {
    // Defensive check: Verify controllers are still usable
    // This prevents crashes when the widget rebuilds after disposal
    // TODO: Fix parent widget lifecycle to prevent this scenario
    try {
      // Try to access controller text to verify it's not disposed
      final isTitleNotEmpty = titleController.text.isNotEmpty;
      
      return _buildForm(context, isTitleNotEmpty);
    } catch (e) {
      // Controllers are disposed - return minimal widget
      return const SizedBox.shrink();
    }
  }

  Widget _buildForm(BuildContext context, bool isTitleNotEmpty) {
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
