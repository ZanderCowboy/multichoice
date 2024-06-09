import 'package:flutter/material.dart';

abstract class AppTypography {
  static const body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static const body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static const h1 = TextStyle(
    fontSize: 96,
    fontWeight: FontWeight.w300,
  );

  static const h2 = TextStyle(
    fontSize: 72,
    fontWeight: FontWeight.w500,
  );

  static const titleLarge = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w400,
  );
  static const titleMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );
  static const titleSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w300,
  );
  static const subtitleLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );
  static const subtitleMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w300,
  );
  static const subtitleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w300,
  );
  static const bodyVeryLarge = TextStyle();
  static const bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  static const bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );
  static const bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w300,
  );
  static const bodyVerySmall = TextStyle();
}
