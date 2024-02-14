import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart' as isar;
import 'package:multichoice/domain/entry/i_entry_repository.dart';
import 'package:multichoice/domain/entry/models/entry.dart';
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
  Future<List<Entry>> readEntries(int tabId) async {
    try {
      final entries = await db.entrys.where().findAll();

      final result =
          entries.where((element) => element.tabId == tabId).toList();

      return result;
    } catch (e) {
      log(e.toString());
      return <Entry>[];
    }
  }

  @override
  Future<List<Entry>?> readAllEntries() async {
    try {
      final entries = await db.entrys.where().findAll();

      return entries;
    } catch (e) {
      log(e.toString());
      return <Entry>[];
    }
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
}
