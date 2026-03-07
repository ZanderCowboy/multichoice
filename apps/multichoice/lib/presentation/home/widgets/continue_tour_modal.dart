import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class ContinueTourModal extends StatelessWidget {
  const ContinueTourModal({
    required this.onFinishTour,
    required this.onContinueTour,
    super.key,
  });

  final VoidCallback onFinishTour;
  final VoidCallback onContinueTour;

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
                'Continue tutorial?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              gap16,
              const Text(
                'You have already started the Multichoice tutorial. '
                'Would you like to continue from where you left off, '
                'or finish the tutorial now?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              gap24,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: onFinishTour,
                    child: const Text('Finish Tour'),
                  ),
                  ElevatedButton(
                    onPressed: onContinueTour,
                    child: const Text('Continue Tour'),
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
