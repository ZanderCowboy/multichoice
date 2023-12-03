import 'package:multichoice/presentation/home/home_page.dart';

abstract class IEntryRepository {
  Future<void> addEntry(int tabIndex, EntryCard entryCard);

  List<EntryCard>? readEntries(int tabIndex);

  Future<void> deleteEntry(int tabIndex, EntryCard entryCard);
}
