import 'package:models/models.dart';

abstract class IEntryRepository {
  Future<int> addEntry({
    required int tabId,
    required String title,
    required String subtitle,
  });

  Future<List<EntryDTO>> readEntries({
    required int tabId,
  });

  Future<List<EntryDTO>> readAllEntries();

  Future<EntryDTO> getEntry({required int entryId});

  Future<int> updateEntry({
    required int id,
    required int tabId,
    required String title,
    required String subtitle,
  });

  Future<bool> deleteEntry({
    required int tabId,
    required int entryId,
  });

  Future<bool> deleteEntries({required int tabId});

  Future<bool> updateEntriesOrder({
    required int tabId,
    required List<int> entryIds,
  });
}
