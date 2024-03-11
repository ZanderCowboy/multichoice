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

  Future<EntryDTO> getEntry(int entryId);

  Future<int> updateEntry(int id, int tabId, String title, String subtitle);

  Future<bool> deleteEntry(
    int tabId,
    int entryId,
  );

  Future<bool> deleteEntries(int tabId);
}
