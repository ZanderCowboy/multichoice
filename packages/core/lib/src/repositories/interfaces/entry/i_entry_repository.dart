import 'package:models/models.dart';

abstract class IEntryRepository {
  Future<int> addEntry(
    int tabId,
    String title,
    String subtitle,
  );

  Future<List<EntryDTO>?> readEntries(
    int tabId,
  );

  Future<List<EntryDTO>?> readAllEntries();

  Future<bool> deleteEntry(
    int tabId,
    int entryId,
  );
}
