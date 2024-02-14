import 'package:multichoice/database_service.dart';
import 'package:multichoice/domain/export_domain.dart';

import 'package:multichoice/get_it_injection.dart';

// TODO(@ZanderCowboy): This can be removed, since it is no longer required

class TabsList {
  TabsList._();
  static final TabsList _instance = TabsList._();
  static TabsList get instance => _instance;

  static final tabsData =
      coreSl<DatabaseService>().database; // Private Constructor

  // create
  int addTab(Tabs tab) {
    tabsData[tab] = [];

    return 0;
  }

  int addEntryToTab(String tabId, Entry entryCard) {
    final tabs = tabsData.keys;
    final tab = tabs.firstWhere((element) {
      return element.id.toString() == tabId;
    });

    if (tab.id.toString().isNotEmpty) {
      tabsData[tab]?.add(entryCard);
    }

    return 0;
  }

  // read
  List<Tabs> readTabs() {
    return tabsData.keys.toList();
  }

  List<Entry>? readEntries(String tabId) {
    final tab =
        tabsData.keys.firstWhere((element) => element.id.toString() == tabId);

    final entries = tabsData[tab]?.toList();
    return entries;
  }

  // update

  // delete tab
  void deleteTab(String tabId) {
    final tab = tabsData.keys.firstWhere(
      (element) => element.id.toString() == tabId,
    );

    tabsData.remove(tab);
  }

  // delete entry in tab
  void deleteEntryInTab(String tabId, String entryId) {
    final tab =
        tabsData.keys.firstWhere((element) => element.id.toString() == tabId);
    final entry = tabsData[tab]
        ?.firstWhere((element) => element.id.toString() == entryId);

    tabsData[tab]?.remove(entry);
  }
}
