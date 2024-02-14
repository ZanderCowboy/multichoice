import 'package:multichoice/domain/export_domain.dart';

// TODO(@ZanderCowboy): This needs to be removed, since it is not needed

abstract class IIsarDB {
  int addTab(Tabs tab);

  int addEntryToTab(String tabId, Entry entryCard);

  List<Tabs> readTabs();

  List<Entry>? readEntries(String tabId);

  int deleteTab(String tabId);

  int deleteEntryInTab(String tabId, String entryId);
}
