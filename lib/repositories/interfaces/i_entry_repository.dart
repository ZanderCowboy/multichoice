import 'package:multichoice/domain/entry/models/entry.dart';

abstract class IEntryRepository {
  Future<int> addEntry(
    int tabId,
    String title,
    String subtitle,
  );

  Future<List<Entry>?> readEntries(
    int tabId,
  );

  Future<List<Entry>?> readAllEntries();

  Future<bool> deleteEntry(
    int tabId,
    int entryId,
  );
}
