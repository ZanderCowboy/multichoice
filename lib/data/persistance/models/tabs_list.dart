import 'package:multichoice/database_service.dart';
import 'package:multichoice/domain/entry/models/entry.dart';
import 'package:multichoice/domain/tabs/models/tabs.dart';
import 'package:multichoice/get_it_injection.dart';

class TabsList {
  static final TabsList _instance = TabsList._internal();
  static TabsList get instance => _instance;

  static final tabsData = coreSl<DatabaseService>().database;

  TabsList._internal(); // Private Constructor

  // create
  int addTab(Tabs tab) {
    tabsData[tab] = [];

    return 0;
  }

  int addEntryToTab(String tabId, Entry entryCard) {
    final tabs = tabsData.keys;
    final Tabs tab = tabs.firstWhere((element) {
      return element.id == tabId;
    });

    if (tab.id.isNotEmpty) {
      tabsData[tab]?.add(entryCard);
    }

    return 0;
  }

  // read
  List<Tabs> readTabs() {
    return tabsData.keys.toList();
  }

  List<Entry>? readEntries(String tabId) {
    final tab = tabsData.keys.firstWhere((element) => element.id == tabId);

    final entries = tabsData[tab]?.toList();
    return entries;
  }

  // update
  List<Tabs> updateTabs(int oldIndex, int newIndex) {
    final List<Tabs> tempTabs = tabsData.keys.toList();
    final int tempLength = tempTabs.length;
    final List<List<Entry>> tempListEntry = tabsData.values.toList();

    final Tabs movedTab = tempTabs.removeAt(oldIndex);
    final List<Entry> movedListEntry = tempListEntry.removeAt(oldIndex);

    if (oldIndex < newIndex && newIndex != tempLength) {
      if (newIndex - oldIndex == 2) {
        tempTabs.insert(newIndex - 1, movedTab);
        tempListEntry.insert(newIndex - 1, movedListEntry);
      } else {
        tempTabs.insert(newIndex - 1, movedTab);
        tempListEntry.insert(newIndex - 1, movedListEntry);
      }
    } else if (oldIndex > newIndex) {
      tempTabs.insert(newIndex, movedTab);
      tempListEntry.insert(newIndex, movedListEntry);
    } else {
      tempTabs.add(movedTab);
      tempListEntry.add(movedListEntry);
    }

    tabsData.clear();
    if (tempTabs.length == tempListEntry.length) {
      for (var i = 0; i < tempTabs.length; i++) {
        final tab = tempTabs[i];
        final listEntry = tempListEntry[i];

        tabsData[tab] = listEntry;
      }
    }

    return tabsData.keys.toList();
  }

  // delete tab
  void deleteTab(String tabId) {
    final tab = tabsData.keys.firstWhere(
      (element) => element.id == tabId,
    );

    tabsData.remove(tab);
  }

  // delete entry in tab
  void deleteEntryInTab(
    String tabId,
    String entryId,
  ) {
    final tab = tabsData.keys.firstWhere((element) => element.id == tabId);
    final entry = tabsData[tab]?.firstWhere((element) => element.id == entryId);

    tabsData[tab]?.remove(entry);
  }
}
