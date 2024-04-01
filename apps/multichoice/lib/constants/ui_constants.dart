import 'package:flutter/material.dart';

const outlinedButtonMinimumSize = Size(96, 48);
const elevatedButtonMinimumSize = Size(96, 48);

const entryCardMinimumSize = null;
const entryCardMinimumHeight = 90.0;
const entryCardMinimumWidth = 0;
const tabCardMinimumWidth = 120.0;
double tabsHeightConstant = 1.15;
double tabsHeightConstantHori = 4;
double tabsWidthConstant = 3.65;

const _mobileScreenWidth = 450;
// const _desktopScreenWidth = 1920;

class UIConstants {
  UIConstants();

  static double? entryHeight(BuildContext context) {
    final mediaHeight = MediaQuery.sizeOf(context).height / 12;

    if (mediaHeight < entryCardMinimumHeight) {
      return entryCardMinimumHeight;
    }
    return mediaHeight;
  }

  static double? horiTabHeight(BuildContext context) {
    return MediaQuery.sizeOf(context).height / 4.1;
  }

  static double? horiTabWidth(BuildContext context) {
    return MediaQuery.sizeOf(context).width;
  }

  static double? horiTabHeaderWidth(BuildContext context) {
    final horizontalTabWidth =
        horiTabWidth(context) ?? MediaQuery.sizeOf(context).width;
    return horizontalTabWidth / 6.25;
  }

  static double? vertTabHeight(BuildContext context) {
    return MediaQuery.sizeOf(context).height / tabsHeightConstant;
  }

  static double? vertTabWidth(BuildContext context) {
    final mediaWidth = MediaQuery.sizeOf(context).width;

    if (mediaWidth > _mobileScreenWidth) {
      tabsWidthConstant = 8;
    }

    final tabsWidth = mediaWidth / tabsWidthConstant;

    if (tabsWidth < tabCardMinimumWidth) {
      return tabCardMinimumWidth;
    }
    return tabsWidth;
  }

  static double? newTabWidth(BuildContext context) {
    return MediaQuery.sizeOf(context).width / 6;
  }
}
