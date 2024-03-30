import 'package:flutter/material.dart';

abstract class AppPalette {
  static const white = Color(0xffffffff);
  static const black = Color(0xff000000);

  static const red = Colors.red;
  static const imperialRed = Color(0xFFE54B4B);

  static const seashell = Color(0xFFF7EBE8);

  static final green = _GreenColors();
  static final grey = _GreyColors();
  static final paletteOne = _PaletteOne();
  static final paletteTwo = _PaletteTwo();
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

  final bigStone = const Color(0xff15203c);
  final sanJuan = const Color(0xff385170);
  final sanJuanLight = const Color(0x7f385170);
  final slateGray = const Color(0xff697a91);
  final towerGray = const Color(0xffa1baba);
  final geyser = const Color(0xffd7e0e5); // primary
  final geyserLight = const Color(0x7fd7e0e5);
}

class _PaletteTwo {
  _PaletteTwo();

  final primary0 = const Color(0xff050a19);
  final primary5 = const Color(0xff121625);
  final primary10 = const Color(0xff8995C1);
  final primary15 = const Color(0xff2A2F3B);
  final primary20 = const Color(0xff373B47);

  final bigStone = const Color(0xff15203C); // primary 171d2c
  final bigStoneLight = const Color(0xff313B54);
  final sanJuan = const Color(0xffe7ecef);
  final sanJuanLight = const Color(0x7f172435);
  final slateGray = const Color(0xff79899D); // 555d68
  final slateGrayLight = const Color(0x7f555d68);
  final towerGray = const Color(0xff4e5c5c);
  final geyser = const Color(0xffDBE3E8); // 172435
  final geyserLight = const Color(0x7f172435);
}

class _PaletteOne {
  final darkSpringGreen = const Color(0xff226f54);
  final pistachio = const Color(0xff87c38f);
  final lemonChiffon = const Color(0xfff4f0bb);
  final black = const Color(0xff000000);
  final quinacridoneMagenta = const Color(0xff8f2d56);
}
