import 'package:flutter/material.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/i18n/strings.g.dart';
import 'package:ui_kit/ui_kit.dart';

class TutorialWelcomeModal extends StatelessWidget {
  const TutorialWelcomeModal({
    required this.onStart,
    super.key,
  });

  final VoidCallback onStart;

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
                context.t.tutorial.welcomeTitle,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              gap16,
              Text(
                context.t.tutorial.welcomeBody,
                textAlign: TextAlign.center,
                style: context.theme.appTextTheme.bodyLarge,
              ),
              gap24,
              ElevatedButton(
                onPressed: onStart,
                child: Text(context.t.common.start),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
