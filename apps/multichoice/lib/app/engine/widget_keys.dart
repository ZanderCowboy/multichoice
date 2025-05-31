import 'package:flutter/material.dart';

class WidgetKeys {
  WidgetKeys._();

  static WidgetKeys instance = WidgetKeys._();

  final deleteModalTitle = const Key('DeleteModalTitle');
  final layoutSwitch = const Key('LayoutSwitch');
  final lightDarkModeSwitch = const Key('LightDarkSwitch');
  final addTabSizedBox = const Key('AddTabSizedBox');
}

extension WidgetKeysExtension on BuildContext {
  WidgetKeys get keys => WidgetKeys.instance;
}
