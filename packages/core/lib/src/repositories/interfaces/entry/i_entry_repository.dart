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

  /// Moves an entry from one tab to another and updates ordering.
  ///
  /// [entryId]: The ID of the entry being moved.
  /// [fromTabId]: The ID of the source tab.
  /// [toTabId]: The ID of the destination tab.
  /// [insertIndex]: The index in the destination tab's entry list where the
  /// entry should be inserted. If out of range, the entry is appended.
  ///
  /// Returns `true` if the move succeeded, otherwise `false`.
  Future<bool> moveEntryToTab({
    required int entryId,
    required int fromTabId,
    required int toTabId,
    required int insertIndex,
  });
}
