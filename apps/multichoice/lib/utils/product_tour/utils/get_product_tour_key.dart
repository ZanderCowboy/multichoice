import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:multichoice/utils/product_tour/product_tour_keys.dart';

GlobalKey? getProductTourKey(dynamic step, {int? tabId}) {
  switch (step) {
    case ProductTourStep.welcomePopup:
      return ProductTourKeys.welcomePopup;
    case ProductTourStep.showCollection:
      return ProductTourKeys.showCollection;
    case ProductTourStep.showItemsInCollection:
      return ProductTourKeys.showItemsInCollection;
    case ProductTourStep.addNewCollection:
      return ProductTourKeys.addNewCollection;
    case ProductTourStep.addNewItem:
      return ProductTourKeys.addNewItem;
    case ProductTourStep.showItemActions:
      return ProductTourKeys.showItemActions;
    case ProductTourStep.showCollectionActions:
      return ProductTourKeys.showCollectionActions;
    case ProductTourStep.showCollectionMenu:
      return ProductTourKeys.showCollectionMenu;
    case ProductTourStep.showSettings:
      return ProductTourKeys.showSettings;
    case ProductTourStep.showAppearanceSection:
      return ProductTourKeys.showAppearanceSection;
    case ProductTourStep.showDataSection:
      return ProductTourKeys.showDataSection;
    case ProductTourStep.showMoreSection:
      return ProductTourKeys.showMoreSection;
    case ProductTourStep.closeSettings:
      return ProductTourKeys.closeSettings;
    case ProductTourStep.thanksPopup:
      return ProductTourKeys.thanksPopup;
    default:
      return null;
  }
}
