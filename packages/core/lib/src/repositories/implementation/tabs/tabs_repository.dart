import 'dart:developer';

import 'package:core/src/repositories/interfaces/tabs/i_tabs_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart' as isar;
import 'package:models/models.dart';
import 'package:uuid/uuid.dart';

@LazySingleton(as: ITabsRepository)
class TabsRepository implements ITabsRepository {
  TabsRepository(this.db);

  final isar.Isar db;

  @override
  Future<int> addTab(String? title, String? subtitle) async {
    try {
      return await db.writeTxn(() async {
        final result = db.tabs.put(
          Tabs(
            uuid: const Uuid().v4(),
            title: title ?? '',
            subtitle: subtitle,
            timestamp: DateTime.now(),
            entryIds: [],
          ),
        );

        return result;
      });
    } catch (e) {
      log(e.toString());
      return 0;
    }
  }

  @override
  Future<List<TabsDTO>> readTabs() async {
    try {
      final tabs = await db.tabs.where().sortByTimestamp().findAll();

      final tabsConverter = TabsMapper();
      final entryConverter = EntryMapper();

      final result = <TabsDTO>[];
      for (final tab in tabs) {
        final tabDTO = tabsConverter.convert<Tabs, TabsDTO>(tab);
        final entryIds = tab.entryIds ?? [];

        final entriesDTO = <EntryDTO>[];
        for (final id in entryIds) {
          final entry = await db.entrys.get(id) ?? Entry.empty();
          final entryDTO = entryConverter.convert<Entry, EntryDTO>(entry);
          entriesDTO.add(entryDTO);
        }

        final newTabDTO = tabDTO.copyWith(entries: entriesDTO);
        result.add(newTabDTO);
      }

      return result;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  @override
  Future<TabsDTO> getTab(int tabId) async {
    try {
      final tabs = await db.tabs.where().findAll();
      final result = tabs.firstWhere((element) => element.id == tabId);

      final dto = TabsMapper().convert<Tabs, TabsDTO>(result);
      final entryIds = result.entryIds ?? [];

      final entriesDTO = <EntryDTO>[];
      for (final id in entryIds) {
        final entry = await db.entrys.get(id) ?? Entry.empty();
        final entryDTO = EntryMapper().convert<Entry, EntryDTO>(entry);
        entriesDTO.add(entryDTO);
      }

      final newTabDTO = dto.copyWith(entries: entriesDTO);

      return newTabDTO;
    } catch (e) {
      log(e.toString());
      return TabsDTO.empty();
    }
  }

  @override
  Future<int> updateTab(int id, String title, String subtitle) async {
    try {
      return await db.writeTxn(() async {
        final tab = await db.tabs.get(id);

        final newTab = tab?.copyWith(title: title, subtitle: subtitle);

        final result = await db.tabs.put(newTab!);

        return result;
      });
    } catch (e) {
      log(e.toString());
      return -1;
    }
  }

  @override
  Future<bool> deleteTab(int? tabId) async {
    try {
      return await db.writeTxn(() async {
        final entries = await db.entrys.where().findAll();

        final tabEntries =
            entries.where((element) => element.tabId == tabId).toList();

        for (final element in tabEntries) {
          await db.entrys.delete(element.id);
        }

        final result = db.tabs.delete(tabId!);

        return result;
      });
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  @override
  Future<bool> deleteTabs() async {
    try {
      return await db.writeTxn(() async {
        await db.entrys.clear();
        await db.tabs.clear();

        if (await db.tabs.count() == 0) {
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
}
