import 'package:flutter/material.dart';

class WidgetKeys {
  WidgetKeys._();

  static WidgetKeys instance = WidgetKeys._();

  final deleteModalTitle = const Key('DeleteModalTitle');
  final addNewEntryTitle = const Key('AddNewEntry');
  final addNewEntryButton = const Key('AddNewEntryButton');
  final layoutSwitch = const Key('LayoutSwitch');
  final addTabSizedBox = const Key('AddTabSizedBox');
  final addNewTabButton = const Key('AddNewTabButton');
}

extension WidgetKeysExtension on BuildContext {
  WidgetKeys get keys => WidgetKeys.instance;
}
