import 'package:flutter/material.dart';

const outlinedButtonMinimumSize = Size(96, 48);
const elevatedButtonMinimumSize = Size(96, 48);

const entryCardMinimumHeight = 90.0;
const entryCardMinimumWidth = 0.0;
const tabCardMinimumWidth = 120.0;
const double tabsHeightConstant = 1.15;
const double tabsHeightConstantHori = 4;
const double tabsWidthConstantMobile = 3.65;
const double tabsWidthConstantDesktop = 8;

/// Vertical

/// Horizontal
const horizontalTabsHeaderFactor = 6.10;

const _mobileScreenWidth = 450;

class UIConstants {
  UIConstants();

  static double _getScreenWidth(BuildContext context) {
    return MediaQuery.sizeOf(context).width;
  }

  static double _getScreenHeight(BuildContext context) {
    return MediaQuery.sizeOf(context).height;
  }

  /// This determines the height of Entry Cards when in Vertical Layout.
  ///
  /// In Horizontal Layout, it has not effect.
  static double entryHeight(BuildContext context) {
    final mediaHeight = _getScreenHeight(context) / 20;

    return mediaHeight < entryCardMinimumHeight
        ? entryCardMinimumHeight
        : mediaHeight;
  }

  static double newTabWidth(BuildContext context) {
    return _getScreenWidth(context) / 6;
  }

  /// Vertical Layout

  /// This determines the height of the collections in Vertical Mode
  static double vertTabHeight(BuildContext context) {
    return _getScreenHeight(context) / tabsHeightConstant;
  }

  static double vertTabWidth(BuildContext context) {
    final mediaWidth = _getScreenWidth(context);
    final tabsWidthConstant = mediaWidth > _mobileScreenWidth
        ? tabsWidthConstantDesktop
        : tabsWidthConstantMobile;

    final tabsWidth = mediaWidth / tabsWidthConstant;

    return tabsWidth < tabCardMinimumWidth ? tabCardMinimumWidth : tabsWidth;
  }

  /// Horizontal Layout
  static double horiTabHeight(BuildContext context) {
    return _getScreenHeight(context) / 4.1;
  }

  /// This controls the size for the header section in Horizontal mode
  static double horiTabHeaderWidth(BuildContext context) {
    return _getScreenWidth(context) / horizontalTabsHeaderFactor;
  }
}
