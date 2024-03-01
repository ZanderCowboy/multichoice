import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart' as isar;
import 'package:multichoice/models/database/entry/entry.dart';
import 'package:multichoice/models/dto/entry/entry_dto.dart';
import 'package:multichoice/models/mappers/entry/entry_dto_mapper.dart';
import 'package:multichoice/repositories/interfaces/entry/i_entry_repository.dart';
import 'package:uuid/uuid.dart';

@LazySingleton(as: IEntryRepository)
class EntryRepository implements IEntryRepository {
  EntryRepository(this.db);

  final isar.Isar db;

  @override
  Future<int> addEntry(int tabId, String title, String subtitle) async {
    try {
      await db.writeTxn(() async {
        final entry = Entry(
          uuid: const Uuid().v4(),
          tabId: tabId,
          title: title,
          subtitle: subtitle,
          timestamp: DateTime.now(),
        );

        final result = db.entrys.put(entry);

        return result;
      });
    } catch (e) {
      log(e.toString());
    }

    return 0;
  }

  @override
  Future<List<EntryDTO>> readEntries(int tabId) async {
    try {
      final entries = await db.entrys.where().sortByTimestamp().findAll();

      final result =
          entries.where((element) => element.tabId == tabId).toList();

      final converter = EntryMapper();
      final entriesDTO = result
          .map((entry) => converter.convert<Entry, EntryDTO>(entry))
          .toList();

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
  Future<int> updateEntry(
    int id,
    int tabId,
    String title,
    String subtitle,
  ) async {
    try {
      await db.writeTxn(() async {
        final entry = await db.entrys.get(id);

        final newEntry = entry?.copyWith(title: title, subtitle: subtitle);

        final result = await db.entrys.put(newEntry!);

        return result;
      });
    } catch (e) {
      log(e.toString());
    }

    return -1;
  }

  @override
  Future<bool> deleteEntry(int tabId, int entryId) async {
    try {
      await db.writeTxn(() async {
        final result = await db.entrys.delete(entryId);

        return result;
      });
    } catch (e) {
      log(e.toString());
    }

    return false;
  }

  @override
  Future<EntryDTO> getEntry(int tabId, int entryId) async {
    try {
      final entriesInTab = await readEntries(tabId);

      final result =
          entriesInTab.firstWhere((element) => element.id == entryId);

      return result;
    } catch (e) {
      log(e.toString());
      return EntryDTO.empty();
    }
  }
}
