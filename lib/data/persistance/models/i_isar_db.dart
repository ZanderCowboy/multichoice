import 'package:multichoice/domain/entry/models/entry.dart';
import 'package:multichoice/domain/tabs/models/tabs.dart';

abstract class IIsarDB {
  int addTab(Tabs tab);

  int addEntryToTab(String tabId, Entry entryCard);

  List<Tabs> readTabs();

  List<Entry>? readEntries(String tabId);

  int deleteTab(String tabId);

  int deleteEntryInTab(String tabId, String entryId);
}
