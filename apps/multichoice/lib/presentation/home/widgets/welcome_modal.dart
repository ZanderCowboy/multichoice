import 'package:flutter/material.dart';

class WelcomeModal extends StatelessWidget {
  const WelcomeModal({
    required this.onGoHome,
    required this.onFollowTutorial,
    super.key,
  });

  final VoidCallback onGoHome;
  final VoidCallback onFollowTutorial;

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
                'Welcome to Multichoice',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Multichoice helps you organize your thoughts and ideas into customizable collections. '
                'Would you like to follow a quick tutorial to learn how to use the app?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: onGoHome,
                    child: const Text('Go Home'),
                  ),
                  ElevatedButton(
                    onPressed: onFollowTutorial,
                    child: const Text('Follow Tutorial'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
