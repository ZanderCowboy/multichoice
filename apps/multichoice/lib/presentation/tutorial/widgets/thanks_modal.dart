import 'package:flutter/material.dart';

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
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Thanks for Completing the Tutorial!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'You now know the basics of using Multichoice. '
                'Feel free to explore and create your own collections!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onGoHome,
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
