import 'package:flutter/material.dart';

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
          padding: const EdgeInsets.all(24),
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
              const SizedBox(height: 16),
              const Text(
                "Let's walk through the main features of Multichoice. "
                "We'll show you how to create collections and add entries.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
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
