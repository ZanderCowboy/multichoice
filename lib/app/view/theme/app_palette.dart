import 'package:flutter/material.dart';

abstract class AppPalette {
  static const red = Colors.red;
  static const imperialRed = Color(0xFFE54B4B);

  static const seashell = Color(0xFFF7EBE8);

  static final green = _GreenColors();
  static final grey = _GreyColors();
  static final paletteOne = _PaletteOne();

  static final titleText = _TitleText();
  static final bodyText = _BodyText();
}

class _GreenColors {
  _GreenColors();

  final greenPea = const Color(0xff26734d);
  final chateauGreen = const Color(0xff37a06b);
  final silverTree = const Color(0xff4eb18b);
  final neptune = const Color(0xff81c1aa);
  final jetStream = const Color(0xffa8d1c8);
}

class _GreyColors {
  _GreyColors();

  // final grey50 = const Color(0xFFFAFAFA);
  // final grey100 = const Color(0xFFFAFAFA);

  final bigStone = const Color(0xff15203c);
  final sanJuan = const Color(0xff385170);
  final slateGray = const Color(0xff697a91);
  final towerGray = const Color(0xffa1baba);
  final geyser = const Color(0xffd7e0e5);
  final geyserLight = const Color(0x7fd7e0e5);
}

class _PaletteOne {
  final darkSpringGreen = const Color(0xff226f54);
  final pistachio = const Color(0xff87c38f);
  final lemonChiffon = const Color(0xfff4f0bb);
  final black = const Color(0xff000000);
  final quinacridoneMagenta = const Color(0xff8f2d56);
}

class _TitleText {
  _TitleText();

  final medium = const Color.fromARGB(123, 28, 185, 11);
}

class _BodyText {
  _BodyText();

  final medium = const Color(0xaaffffff);
}
