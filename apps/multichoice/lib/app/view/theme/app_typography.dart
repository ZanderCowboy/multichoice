// ignore_for_file: unused_field

part of 'app_theme.dart';

/// Base text styles for the app: **font size and weight only**.
///
/// Colors and letter spacing are applied in the theme text extension (see
/// `light_text_theme.dart` / `dark_text_theme.dart`). Prefer
/// `Theme.of(context).extension<...>()` for themed text, and use these
/// constants when you need the raw scale (e.g. one-off [TextStyle.copyWith]).
abstract class _AppTypography {
  /// Heading
  static const heading1 = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w500,
  );
  static const heading2 = TextStyle(
    fontSize: 42,
    fontWeight: FontWeight.w500,
  );
  static const heading3 = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w500,
  );
  static const heading4 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w500,
  );
  static const heading5 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w500,
  );
  static const heading6 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
  );

  /// Title
  static const title1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );
  static const title2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w500,
  );
  static const title3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
  );
  static const title4 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w300,
  );
  static const title5 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w200,
  );
  static const title6 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w200,
  );

  /// Subtitle
  static const subtitle1 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
  static const subtitle2 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  static const subtitle3 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w300,
  );
  static const subtitle4 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w300,
  );
  static const subtitle5 = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w200,
  );
  static const subtitle6 = TextStyle(
    fontSize: 8,
    fontWeight: FontWeight.w200,
  );

  /// Body
  static const body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  static const body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  static const body3 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );
  static const body4 = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w300,
  );
  static const body5 = TextStyle(
    fontSize: 8,
    fontWeight: FontWeight.w200,
  );
  static const body6 = TextStyle(
    fontSize: 6,
    fontWeight: FontWeight.w200,
  );
}
