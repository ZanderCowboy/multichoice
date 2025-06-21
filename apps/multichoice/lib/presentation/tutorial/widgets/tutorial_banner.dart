import 'package:flutter/material.dart';

class TutorialBanner extends StatelessWidget {
  const TutorialBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      right: -40,
      child: Transform.rotate(
        angle: 0.785398, // 45 degrees in radians
        child: Container(
          color: Colors.red,
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 2,
          ),
          child: const Text(
            'TUTORIAL',
            style: TextStyle(
              color: Colors.white,
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
