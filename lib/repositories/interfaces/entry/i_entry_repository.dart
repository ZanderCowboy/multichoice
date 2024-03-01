import 'package:multichoice/models/dto/entry/entry_dto.dart';

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

  Future<EntryDTO> getEntry(int tabId, int entryId);

  Future<int> updateEntry(int id, int tabId, String title, String subtitle);

  Future<bool> deleteEntry(
    int tabId,
    int entryId,
  );
}
