import 'package:flutter/material.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/i18n/strings.g.dart';
import 'package:ui_kit/ui_kit.dart';

class ThanksModal extends StatelessWidget {
  const ThanksModal({
    required this.onGoHome,
    super.key,
  });

  final VoidCallback onGoHome;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        child: Padding(
          padding: allPadding24,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.t.tutorial.thanksTitle,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              gap16,
              Text(
                context.t.tutorial.thanksBody,
                textAlign: TextAlign.center,
                style: context.theme.appTextTheme.bodyLarge,
              ),
              gap24,
              ElevatedButton(
                onPressed: onGoHome,
                child: Text(context.t.common.goHome),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
