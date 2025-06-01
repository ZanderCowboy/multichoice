import 'package:flutter/material.dart';

class WidgetKeys {
  WidgetKeys._();

  static WidgetKeys instance = WidgetKeys._();

  final deleteModalTitle = const Key('DeleteModalTitle');
  final addNewEntryTitle = const Key('AddNewEntryTitle');
  final addNewEntryButton = const Key('AddNewEntryButton');
  final layoutSwitch = const Key('LayoutSwitch');
  final lightDarkModeSwitch = const Key('LightDarkSwitch');
  final addTabSizedBox = const Key('AddTabSizedBox');
  final addNewTabButton = const Key('AddNewTabButton');
  final deleteAllDataButton = const Key('DeleteAllDataButton');
  final importExportDataButton = const Key('ImportExportDataButton');
}

extension WidgetKeysExtension on BuildContext {
  WidgetKeys get keys => WidgetKeys.instance;
}
