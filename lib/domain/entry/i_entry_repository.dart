import 'package:multichoice/presentation/home/home_page.dart';

abstract class IEntryRepository {
  Future<void> addEntry(
      int tabIndex, VerticalTab verticalTab, EntryCard entryCard);

  List<EntryCard>? readEntries(int tabIndex, VerticalTab verticalTab);

  Future<void> deleteEntry(
    int tabIndex,
    VerticalTab verticalTab,
    int entryIndex,
    EntryCard entryCard,
  );
}
