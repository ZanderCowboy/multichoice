import 'package:flutter/material.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/i18n/strings.g.dart';
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
      constraints: const BoxConstraints(maxWidth: 460),
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
                  context.t.common.updateAvailable,
                  style: context.appTextTheme.titleMedium,
                ),
                gap4,
                Text(
                  context.t.common.updateAvailableDescription,
                  style: context.appTextTheme.bodyMedium,
                ),
                gap12,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: onLater,
                      child: Text(context.t.home.later),
                    ),
                    gap8,
                    ElevatedButton(
                      onPressed: onUpdate,
                      child: Text(context.t.common.update),
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
