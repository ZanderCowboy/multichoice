import 'package:multichoice/domain/entry/models/entry.dart';

abstract class IEntryRepository {
  Future<int> addEntry(
    String tabId,
    String title,
    String subtitle,
  );

  List<Entry>? readEntries(
    String tabId,
  );

  Future<int> deleteEntry(
    String tabId,
    String entryId,
  );
}
