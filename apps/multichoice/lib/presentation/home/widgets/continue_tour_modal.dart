import 'package:flutter/material.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/i18n/strings.g.dart';
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
              Text(
                context.t.common.continueTutorial,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              gap16,
              Text(
                context.t.common.continueTutorialBody,
                textAlign: TextAlign.center,
                style: context.theme.appTextTheme.bodyLarge,
              ),
              gap24,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: onFinishTour,
                    child: Text(context.t.common.finishTour),
                  ),
                  ElevatedButton(
                    onPressed: onContinueTour,
                    child: Text(context.t.common.continueTour),
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
