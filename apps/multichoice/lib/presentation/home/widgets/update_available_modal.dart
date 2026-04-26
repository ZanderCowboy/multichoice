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
    return SafeArea(
      top: false,
      child: Padding(
        padding: allPadding16,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Update available',
              style: context.appTextTheme.headingMedium,
            ),
            gap8,
            Text(
              'A newer version of Multichoice is available on the Play Store.',
              style: context.appTextTheme.subtitleMedium,
            ),
            gap16,
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onLater,
                    child: const Text('Later'),
                  ),
                ),
                gap12,
                Expanded(
                  child: ElevatedButton(
                    onPressed: onUpdate,
                    child: const Text('Update'),
                  ),
                ),
              ],
            ),
            gap8,
          ],
        ),
      ),
    );
  }
}
