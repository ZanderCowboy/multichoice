import 'package:flutter/material.dart';

class TourController {
  static final Map<int, String> tourSteps = {
    0: "Welcome to Multichoice! Let's get started with a quick tour.",
    1: 'This is where you can add a new collection. Tap the + button to create one.',
    2: 'To add an item to your collection, tap the + button in the collection.',
    3: 'Tap on any item to view its details.',
    4: 'Double tap on an item or collection to edit it.',
    5: 'Long press on items or collections to see more options like delete.',
    6: 'Open the menu to access settings and other features.',
    7: 'In settings, you can customize your app experience.',
  };

  static final Map<int, GlobalKey> tourKeys = {
    0: GlobalKey(),
    1: GlobalKey(),
    2: GlobalKey(),
    3: GlobalKey(),
    4: GlobalKey(),
    5: GlobalKey(),
    6: GlobalKey(),
    7: GlobalKey(),
  };

  static String getStepDescription(int step) {
    return tourSteps[step] ?? 'Step $step';
  }

  static GlobalKey getStepKey(int step) {
    return tourKeys[step] ?? GlobalKey();
  }
}
