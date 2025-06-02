enum ProductTourStep {
  welcomePopup(0),
  showCollection(1),
  showItemsInCollection(2),
  addNewCollection(3),
  addNewItem(4),
  showItemActions(5),
  showCollectionActions(6),
  showCollectionMenu(7),
  showSettings(8),
  thanksPopup(9),
  none(-1),
  reset(-2),
  ;

  const ProductTourStep(this.value);

  final int value;
}
