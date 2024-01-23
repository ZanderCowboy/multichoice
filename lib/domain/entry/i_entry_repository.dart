import 'package:multichoice/domain/entry/models/entry.dart';

abstract class IEntryRepository {
  Future<int> addEntry(
    String tabId,
    Entry entry,
  );

  List<Entry>? readEntries(
    String tabId,
  );

  Future<int> deleteEntry(
    String tabId,
    String entryId,
  );
}
