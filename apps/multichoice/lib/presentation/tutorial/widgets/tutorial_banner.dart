import 'package:flutter/material.dart';
import 'package:multichoice/app/export.dart';

class TutorialBanner extends StatelessWidget {
  const TutorialBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = context.theme.appColors.primary;
    final onPrimary = context.theme.appColors.filledButtonForeground;

    return Positioned(
      top: 20,
      right: -40,
      child: Transform.rotate(
        angle: 0.785398, // 45 degrees in radians
        child: Container(
          color: primary,
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 2,
          ),
          child: Text(
            'TUTORIAL',
            style: TextStyle(
              color: onPrimary,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}
