import 'package:injectable/injectable.dart';
import 'package:multichoice/data/persistance/models/entries_list.dart';
import 'package:multichoice/domain/entry/i_entry_repository.dart';
import 'package:multichoice/presentation/home/home_page.dart';

@LazySingleton(as: IEntryRepository)
class EntryRepository implements IEntryRepository {
  EntryRepository();

  EntriesList entriesList = EntriesList();

  @override
  Future<void> addEntry(int tabIndex, EntryCard entryCard) async {
    entriesList.addEntry(tabIndex, entryCard);
  }

  @override
  Future<void> deleteEntry(int tabIndex, EntryCard entryCard) async {
    entriesList.deleteEntry(tabIndex, entryCard);
  }

  @override
  List<EntryCard>? readEntries(int tabIndex) {
    return entriesList.readEntries(tabIndex);
  }
}
