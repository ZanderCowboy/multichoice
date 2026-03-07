enum ProductTourStep {
  welcomePopup(0),
  showCollection(1),
  showItemsInCollection(2),
  addNewCollection(3),
  addNewItem(4),
  showItemActions(5),
  showCollectionActions(6),
  showCollectionMenu(7),
  showEditAndSearch(8),
  showSettings(9),
  showAppearanceSection(10),
  showDataSection(11),
  showMoreSection(12),
  closeSettings(13),
  thanksPopup(14),
  noneCompleted(-1),
  reset(-2),
  ;

  const ProductTourStep(this.value);

  final int value;
}
