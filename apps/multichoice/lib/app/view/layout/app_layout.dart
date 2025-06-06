import 'package:core/core.dart';
import 'package:flutter/material.dart';

class AppLayout extends ChangeNotifier {
  AppLayout() {
    _loadLayoutPreference();
  }

  final _appStorageService = coreSl<IAppStorageService>();
  bool _isLayoutVertical = false;

  bool get isLayoutVertical => _isLayoutVertical;

  Future<void> _loadLayoutPreference() async {
    _isLayoutVertical = await _appStorageService.isLayoutVertical;
    notifyListeners();
  }

  Future<void> setLayoutVertical({required bool isVertical}) async {
    if (_isLayoutVertical == isVertical) return;

    _isLayoutVertical = isVertical;
    await _appStorageService.setIsLayoutVertical(isVertical);
    notifyListeners();
  }
}
