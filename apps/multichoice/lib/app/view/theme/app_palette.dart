// ignore_for_file: unused_field

part of 'app_theme.dart';

/// Base color values for the app: **raw [Color] constants only**.
///
/// Themed surfaces and on-colors are wired in `light_colors.dart` /
/// `dark_colors.dart` and extensions. Prefer theme extensions for UI; use
/// these when defining theme data or for one-off [Color] needs.
abstract class _AppPalette {
  /// Primary
  static const white = Color(0xffffffff);
  static const black = Color(0xff000000);
  static const transparent = Color(0x00000000);
  static const lightGrey = Color(0xffF5F5F5);
  static const enabledColor = Color(0xffF0F0F0);
  static const disabledColor = Color(0x80FFFFFF);
  static const MaterialColor red = Colors.red;
  static const imperialRed = Color(0xFFE54B4B);
  static const seashell = Color(0xFFF7EBE8);

  /// Green
  static const greenPea = Color(0xff26734d);
  static const chateauGreen = Color(0xff37a06b);
  static const silverTree = Color(0xff4eb18b);
  static const neptune = Color(0xff81c1aa);
  static const jetStream = Color(0xffa8d1c8);

  /// Grey
  static const bigStoneTone1 = Color(0xff15203c);
  static const sanJuanTone1 = Color(0xff385170);
  static const sanJuanLightTone1 = Color(0x7f385170);
  static const slateGrayTone1 = Color(0xff697a91);
  static const towerGrayTone1 = Color(0xffa1baba);
  static const geyserTone1 = Color(0xffd7e0e5);
  static const geyserLightTone1 = Color(0x7fd7e0e5);

  /// Palette one
  static const darkSpringGreen = Color(0xff226f54);
  static const pistachio = Color(0xff87c38f);
  static const lemonChiffon = Color(0xfff4f0bb);
  static const quinacridoneMagenta = Color(0xff8f2d56);

  /// Palette two
  static const primary0 = Color(0xff050a19);
  static const primary5 = Color(0xff121625);
  static const primary10 = Color(0xff8995C1);
  static const primary15 = Color(0xff2A2F3B);
  static const primary20 = Color(0xff373B47);
  static const bigStoneTone2 = Color(0xff15203C);
  static const bigStoneLight = Color(0xff313B54);
  static const sanJuanTone2 = Color(0xffe7ecef);
  static const sanJuanLightTone2 = Color(0x7f172435);
  static const slateGrayTone2 = Color(0xff79899D);
  static const slateGrayLight = Color(0x7f555d68);
  static const towerGrayTone2 = Color(0xff4e5c5c);
  static const geyserTone2 = Color(0xffDBE3E8);
  static const geyserLightTone2 = Color(0x7f172435);
}
