import 'package:core/core.dart';
import 'package:flutter/material.dart';

class AppLayout extends ChangeNotifier {
  AppLayout() {
    _initialize();
  }

  final _appStorageService = coreSl<IAppStorageService>();
  bool _isLayoutVertical = false;
  bool _isInitialized = false;

  bool get isLayoutVertical => _isLayoutVertical;
  bool get isInitialized => _isInitialized;

  Future<void> _initialize() async {
    await _loadLayoutPreference();
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _loadLayoutPreference() async {
    _isLayoutVertical = await _appStorageService.isLayoutVertical;
  }

  Future<void> setLayoutVertical({required bool isVertical}) async {
    if (_isLayoutVertical == isVertical) return;

    _isLayoutVertical = isVertical;
    await _appStorageService.setIsLayoutVertical(isVertical);
    notifyListeners();
  }
}
