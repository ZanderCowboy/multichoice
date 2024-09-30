import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

class ShowcaseManager {
  static bool _value = false;
  static bool getNewEntry() => _value;
  static void setHasNewEntry() {
    _value = true;
  }

  final _addTabCardKey = GlobalKey<State<StatefulWidget>>();
  final _addEntryCardKey = GlobalKey<State<StatefulWidget>>();
  final _tabsMenu = GlobalKey<State<StatefulWidget>>();
  final _entryMenu = GlobalKey<State<StatefulWidget>>();
  final _editEntry = GlobalKey<ShowCaseWidgetState>();
  final _backButton = GlobalKey<State<StatefulWidget>>();
  final _popScope = GlobalKey<ShowCaseWidgetState>();
  final _settings = GlobalKey<ShowCaseWidgetState>();
  final _search = GlobalKey<ShowCaseWidgetState>();
  final _close = GlobalKey<ShowCaseWidgetState>();
  final _info = GlobalKey<ShowCaseWidgetState>();

  GlobalKey<State<StatefulWidget>> get addTabCardKey => _addTabCardKey;
  GlobalKey<State<StatefulWidget>> get addEntryCardKey => _addEntryCardKey;
  GlobalKey<State<StatefulWidget>> get tabsMenu => _tabsMenu;
  GlobalKey<State<StatefulWidget>> get entryMenu => _entryMenu;
  GlobalKey<ShowCaseWidgetState> get editEntry => _editEntry;
  GlobalKey<State<StatefulWidget>> get backButton => _backButton;
  GlobalKey<ShowCaseWidgetState> get pop => _popScope;
  GlobalKey<ShowCaseWidgetState> get openSettings => _settings;
  GlobalKey<ShowCaseWidgetState> get searchButton => _search;
  GlobalKey<ShowCaseWidgetState> get closeButton => _close;
  GlobalKey<ShowCaseWidgetState> get info => _info;

  void startShowcase(BuildContext context) {
    if (!ShowcaseController.isShowcaseFinished) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(context)
          ..startShowCase([
            _addTabCardKey,
          ]);
      });
      coreSl<SharedPreferences>().setBool(Keys.hasShowcaseStarted, true);
    }
  }

  void startAddEntryShowcase(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowCaseWidget.of(context).startShowCase([
        _addEntryCardKey,
      ]);
      ShowCaseWidget.of(context).completed(_addTabCardKey);
    });
  }

  void startTabsMenuShowcase(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowCaseWidget.of(context).startShowCase([
        _tabsMenu,
      ]);
      ShowCaseWidget.of(context).completed(_addEntryCardKey);
      ShowcaseController.setShowcaseFinished();
    });
  }

  void startEntryMenuShowcase(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowCaseWidget.of(context).startShowCase([
        _entryMenu,
      ]);
    });
    coreSl<SharedPreferences>().setBool(Keys.isStepOneFinished, true);
  }

  void startEditEntryShowcase(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowCaseWidget.of(context).startShowCase([
        _editEntry,
      ]);
    });
    coreSl<SharedPreferences>().setBool(Keys.isStepTwoFinished, true);
  }

  void startBackButtonShowcase(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowCaseWidget.of(context).startShowCase([
        _backButton,
      ]);
    });
  }

  void startPopShowcase(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowCaseWidget.of(context).startShowCase([
        _popScope,
      ]);
    });
  }

  void startSearchShowcase(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowCaseWidget.of(context).startShowCase([
        _search,
      ]);
    });
  }

  void startSettingsShowcase(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowCaseWidget.of(context).startShowCase([
        _settings,
      ]);
    });
    coreSl<SharedPreferences>().setBool(Keys.isStepThreeFinished, true);
  }

  void startInfoShowcase(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowCaseWidget.of(context).startShowCase([
        _info,
      ]);
    });
    coreSl<SharedPreferences>().setBool(Keys.isStepFourFinished, true);
  }

  void startCloseShowcase(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () {
        ShowCaseWidget.of(context).startShowCase([
          _close,
        ]);
      });
    });
    coreSl<SharedPreferences>().setBool(Keys.isShowcaseFinished, true);
  }

  void previous(BuildContext context) {
    ShowCaseWidget.of(context).previous();
  }

  void next(BuildContext context) {
    ShowCaseWidget.of(context).next();
  }

  void close(BuildContext context) {
    ShowCaseWidget.of(context).completed(addEntryCardKey);
  }
}

class ShowcaseController {
  static final _prefs = coreSl<SharedPreferences>();
  static bool _isShowcaseFinished = false;

  static bool _isShowcaseFinised() =>
      _prefs.getBool('isShowcaseFinished') ?? _isShowcaseFinished;

  static void setShowcaseFinished() {
    _isShowcaseFinished = !_isShowcaseFinished;
    _prefs.setBool('isShowcaseFinished', _isShowcaseFinished);
  }

  static void resetShowcase() {
    _prefs.setBool('isShowcaseFinished', false);
  }

  static bool get isShowcaseFinished => _isShowcaseFinised();
}
