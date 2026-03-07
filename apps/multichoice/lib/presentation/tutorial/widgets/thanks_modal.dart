import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class ThanksModal extends StatelessWidget {
  const ThanksModal({
    required this.onGoHome,
    super.key,
  });

  final VoidCallback onGoHome;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: allPadding24,
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
            gap16,
            const Text(
              'You now know the basics of using Multichoice. '
              'Feel free to explore and create your own collections!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            gap24,
            ElevatedButton(
              onPressed: onGoHome,
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
