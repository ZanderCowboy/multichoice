import 'package:flutter/material.dart';
import 'package:multichoice/app/export.dart';
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
              const Text(
                'Welcome to the Tutorial',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              gap16,
              Text(
                "Let's walk through the main features of Multichoice. "
                "We'll show you how to create collections and add entries.",
                textAlign: TextAlign.center,
                style: context.theme.appTextTheme.bodyLarge,
              ),
              gap24,
              ElevatedButton(
                onPressed: onStart,
                child: const Text('Start'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
