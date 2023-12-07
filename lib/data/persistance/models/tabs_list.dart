import 'package:multichoice/presentation/home/home_page.dart';

class TabsList {
  TabsList();

  static final Map<VerticalTab, List<EntryCard>> tabsData = {};

  // create
  void addTab(VerticalTab verticalTab) {
    tabsData[verticalTab] = [];
  }

  void addEntryToTab(VerticalTab verticalTab, EntryCard entryCard) {
    tabsData[verticalTab]?.add(entryCard);
  }

  // read
  List<VerticalTab> readTabs() {
    return tabsData.keys.toList();
  }

  List<EntryCard>? readEntries(VerticalTab verticalTab) {
    return tabsData[verticalTab]?.toList();
  }

  // update

  // delete
  void deleteTab(
    int tabIndex,
    VerticalTab verticalTab,
  ) {
    tabsData.remove(verticalTab);
  }

  void deleteEntryInTab(
    VerticalTab verticalTab,
    int entryIndex,
    EntryCard entryCard,
  ) {
    tabsData[verticalTab]?.removeAt(entryIndex);
  }
}
