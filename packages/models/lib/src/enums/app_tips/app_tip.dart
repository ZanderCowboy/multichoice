/// Contextual, non-blocking tips shown on the home screen.
enum AppTip {
  collections(0),
  addCollection(1),
  addEntry(2),
  entryActions(3),
  editAndSearch(4),
  drawer(5),
  ;

  const AppTip(this.bitIndex);

  final int bitIndex;

  int get mask => 1 << bitIndex;

  static const List<AppTip> orderedTips = [
    collections,
    addCollection,
    addEntry,
    entryActions,
    editAndSearch,
    drawer,
  ];

  static AppTip? firstUndismissed(int dismissedMask) {
    for (final tip in orderedTips) {
      if ((dismissedMask & tip.mask) == 0) {
        return tip;
      }
    }

    return null;
  }

  static int allDismissedMask = orderedTips.fold(
    0,
    (mask, tip) => mask | tip.mask,
  );
}
