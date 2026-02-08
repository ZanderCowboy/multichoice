import 'dart:developer';

import 'package:core/src/repositories/interfaces/entry/i_entry_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:isar_community/isar.dart' as isar;
import 'package:models/models.dart';
import 'package:uuid/uuid.dart';

@LazySingleton(as: IEntryRepository)
class EntryRepository implements IEntryRepository {
  EntryRepository(this.db);

  final isar.Isar db;

  @override
  Future<int> addEntry({
    required int tabId,
    required String title,
    required String subtitle,
  }) async {
    try {
      return await db.writeTxn(() async {
        final entry = Entry(
          uuid: const Uuid().v4(),
          tabId: tabId,
          title: title,
          subtitle: subtitle,
          timestamp: DateTime.now(),
        );

        final tab = await db.tabs.get(tabId);
        final entryIds = [...tab?.entryIds ?? <int>[], entry.id];
        final newTab = tab?.copyWith(entryIds: entryIds) ?? Tabs.empty();

        await db.tabs.put(newTab);
        final result = await db.entrys.put(entry);

        return result;
      });
    } on isar.IsarError catch (e, s) {
      log(e.toString(), error: e, stackTrace: s);
      return -1;
    } on Exception catch (e, s) {
      log(e.toString(), error: e, stackTrace: s);
      return -1;
    }
  }

  @override
  Future<EntryDTO> getEntry({required int entryId}) async {
    try {
      final entry = await db.entrys.get(entryId) ?? Entry.empty();

      final result = EntryMapper().convert<Entry, EntryDTO>(entry);

      return result;
    } catch (e) {
      log(e.toString());
      return EntryDTO.empty();
    }
  }

  @override
  Future<List<EntryDTO>> readEntries({required int tabId}) async {
    try {
      // Get the tab to access the ordered entryIds list
      final tab = await db.tabs.get(tabId);
      final entryIds = tab?.entryIds ?? [];

      final converter = EntryMapper();
      final entriesDTO = <EntryDTO>[];

      // Retrieve entries in the order specified by entryIds
      for (final id in entryIds) {
        final entry = await db.entrys.get(id);
        if (entry != null) {
          final entryDTO = converter.convert<Entry, EntryDTO>(entry);
          entriesDTO.add(entryDTO);
        }
      }

      return entriesDTO;
    } catch (e) {
      log(e.toString());
      return <EntryDTO>[];
    }
  }

  @override
  Future<List<EntryDTO>> readAllEntries() async {
    try {
      final entries = await db.entrys.where().sortByTimestamp().findAll();

      final converter = EntryMapper();
      final entriesDTO = entries
          .map((entry) => converter.convert<Entry, EntryDTO>(entry))
          .toList();

      return entriesDTO;
    } catch (e) {
      log(e.toString());
      return <EntryDTO>[];
    }
  }

  @override
  Future<int> updateEntry({
    required int id,
    required int tabId,
    required String title,
    required String subtitle,
  }) async {
    try {
      return await db.writeTxn(() async {
        final entry = await db.entrys.get(id);

        final newEntry = entry?.copyWith(title: title, subtitle: subtitle);

        final result = await db.entrys.put(newEntry!);

        return result;
      });
    } catch (e) {
      log(e.toString());
      return -1;
    }
  }

  @override
  Future<bool> deleteEntry({
    required int tabId,
    required int entryId,
  }) async {
    try {
      return await db.writeTxn(() async {
        final result = await db.entrys.delete(entryId);

        final tab = await db.tabs.get(tabId) ?? Tabs.empty();
        final entryIds = [...tab.entryIds ?? <int>[]];
        final removed = entryIds.remove(entryId);
        final newTab = tab.copyWith(entryIds: entryIds);

        if (removed) {
          await db.tabs.put(newTab);
        }

        return result;
      });
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  @override
  Future<bool> deleteEntries({required int tabId}) async {
    try {
      return await db.writeTxn(() async {
        final tab = await db.tabs.get(tabId) ?? Tabs.empty();
        final entryIds = tab.entryIds ?? [];

        await db.entrys.deleteAll(entryIds);

        final newTab = tab.copyWith(entryIds: null);
        await db.tabs.put(newTab);

        if ((await db.tabs.get(tabId))?.entryIds == null) {
          return true;
        } else {
          return false;
        }
      });
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  /// Updates the order of entries within a tab.
  ///
  /// [tabId]: The ID of the tab containing the entries.
  /// [entryIds]: The list of entry IDs in the new order.
  ///
  /// Returns `true` if the entries were successfully reordered, otherwise `false`.
  @override
  Future<bool> updateEntriesOrder({
    required int tabId,
    required List<int> entryIds,
  }) async {
    try {
      return await db.writeTxn(() async {
        final tab = await db.tabs.get(tabId);
        if (tab != null) {
          final updatedTab = tab.copyWith(entryIds: entryIds);
          await db.tabs.put(updatedTab);
          return true;
        }
        return false;
      });
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
