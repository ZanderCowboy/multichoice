import 'package:flutter/material.dart';
import 'package:multichoice/app/export.dart';
import 'package:ui_kit/ui_kit.dart';

class UpdateAvailableModal extends StatelessWidget {
  const UpdateAvailableModal({
    required this.onUpdate,
    required this.onLater,
    super.key,
  });

  final VoidCallback onUpdate;
  final VoidCallback onLater;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 520),
      child: Padding(
        padding: horizontal16,
        child: Material(
          color: context.theme.colorScheme.surface,
          elevation: 8,
          borderRadius: borderCircular16,
          child: Padding(
            padding: allPadding16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Update available',
                  style: context.appTextTheme.titleMedium,
                ),
                gap4,
                Text(
                  'A newer version of Multichoice is available on the Play Store.',
                  style: context.appTextTheme.bodyMedium,
                ),
                gap12,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: onLater,
                      child: const Text('Later'),
                    ),
                    gap8,
                    ElevatedButton(
                      onPressed: onUpdate,
                      child: const Text('Update'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
