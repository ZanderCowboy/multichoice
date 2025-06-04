import 'package:flutter/material.dart';

class ProductTourKeys {
  static final GlobalKey welcomePopup = GlobalKey(debugLabel: 'welcomePopup');
  static final GlobalKey showCollection =
      GlobalKey(debugLabel: 'showCollection');
  static final GlobalKey showItemsInCollection =
      GlobalKey(debugLabel: 'showItemsInCollection');
  static final GlobalKey addNewCollection =
      GlobalKey(debugLabel: 'addNewCollection');
  static final GlobalKey addNewItem = GlobalKey(debugLabel: 'addNewItem');
  static final GlobalKey showItemActions =
      GlobalKey(debugLabel: 'showItemActions');
  static final GlobalKey showCollectionActions = GlobalKey();
  static final GlobalKey showCollectionMenu =
      GlobalKey(debugLabel: 'showCollectionMenu');
  static final GlobalKey showSettings = GlobalKey(debugLabel: 'showSettings');
  static final GlobalKey showDetails = GlobalKey(debugLabel: 'showDetails');
  static final GlobalKey closeSettings = GlobalKey(debugLabel: 'closeSettings');
  static final GlobalKey thanksPopup = GlobalKey(debugLabel: 'thanksPopup');
}
