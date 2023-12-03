import 'package:multichoice/presentation/home/home_page.dart';

class EntriesList {
  EntriesList();

  // final numberOfTabs = TabsList().readTabs().length;
  static final Map<int, List<EntryCard>> entriesList = {};

  // create
  void addEntry(int tabIndex, EntryCard entryCard) {
    entriesList[tabIndex]?.add(entryCard);
  }

  // read
  List<EntryCard>? readEntries(int tabIndex) {
    return entriesList[tabIndex];
  }

  // update

  // delete
  void deleteEntry(int tabIndex, EntryCard entryCard) {
    // todo add index to remove entries at index
    entriesList[tabIndex]?.remove(entryCard);
  }
}
