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
  showAppearanceSection(9),
  showDataSection(10),
  showMoreSection(11),
  closeSettings(12),
  thanksPopup(13),
  noneCompleted(-1),
  reset(-2),
  ;

  const ProductTourStep(this.value);

  final int value;
}
