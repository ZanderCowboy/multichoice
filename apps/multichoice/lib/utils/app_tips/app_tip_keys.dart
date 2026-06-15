import 'package:flutter/material.dart';
import 'package:models/models.dart';

/// Global keys for showcase targets on the home screen.
class AppTipKeys {
  AppTipKeys._();

  static final AppTipKeys instance = AppTipKeys._();

  final GlobalKey<State<StatefulWidget>> collections = GlobalKey();
  final GlobalKey<State<StatefulWidget>> addCollection = GlobalKey();
  final GlobalKey<State<StatefulWidget>> addEntry = GlobalKey();
  final GlobalKey<State<StatefulWidget>> entryActions = GlobalKey();
  final GlobalKey<State<StatefulWidget>> editAndSearch = GlobalKey();
  final GlobalKey<State<StatefulWidget>> drawerMenu = GlobalKey();
  final GlobalKey<State<StatefulWidget>> drawerAppearance = GlobalKey();

  GlobalKey? forTip(AppTip tip) {
    return switch (tip) {
      AppTip.collections => collections,
      AppTip.addCollection => addCollection,
      AppTip.addEntry => addEntry,
      AppTip.entryActions => entryActions,
      AppTip.editAndSearch => editAndSearch,
      AppTip.drawer => drawerMenu,
    };
  }
}

final AppTipKeys appTipKeys = AppTipKeys.instance;
