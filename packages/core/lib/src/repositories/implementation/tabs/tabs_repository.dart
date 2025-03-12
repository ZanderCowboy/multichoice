import 'dart:developer';

import 'package:core/src/repositories/interfaces/tabs/i_tabs_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart' as isar;
import 'package:models/models.dart';
import 'package:uuid/uuid.dart';
import 'package:clock/clock.dart';

@LazySingleton(as: ITabsRepository)
class TabsRepository implements ITabsRepository {
  TabsRepository(this.db);

  final isar.Isar db;

  /// Adds a new tab to the database.
  ///
  /// [title]: The title of the tab. If `null`, an empty string is used.
  /// [subtitle]: The subtitle of the tab.
  ///
  /// Returns the [int] ID of the newly added tab, or `0` if an error occurs.
  @override
  Future<int> addTab(String? title, String? subtitle) async {
    try {
      return await db.writeTxn(() async {
        final result = db.tabs.put(
          Tabs(
            uuid: const Uuid().v4(),
            title: title ?? '',
            subtitle: subtitle,
            timestamp: clock.now(),
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

  /// Reads all tabs from the database.
  ///
  /// Returns a [List] of [TabsDTO] representing all tabs, or an empty list if an error occurs.
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

  /// Retrieves a specific tab by its [int] ID.
  ///
  /// [tabId]: The ID of the tab to retrieve.
  ///
  /// Returns a [TabsDTO] representing the tab, or an empty [TabsDTO] if an error occurs.
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

  /// Updates the title and subtitle of a specific tab given its [int] ID.
  ///
  /// [id]: The ID of the tab to update.
  /// [title]: The new title of the tab.
  /// [subtitle]: The new subtitle of the tab.
  ///
  /// Returns the [int] ID of the updated tab, or `-1` if an error occurs.
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

  /// Deletes a tab and its associated entries from the database.
  ///
  /// This method performs the following steps:
  /// 1. Retrieves all entries from the database.
  /// 2. Filters the entries to find those associated with the given [tabId].
  /// 3. Deletes each of the filtered entries.
  /// 4. Deletes the tab with the given [tabId].
  ///
  /// If an error occurs during the process, it logs the error and returns `false`.
  ///
  /// Returns `true` if the tab and its entries were successfully deleted, otherwise `false`.
  ///
  /// [tabId]: The ID of the tab to be deleted. If `null`, the method will return `false`.
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

  /// Deletes all tabs and their associated entries from the database.
  ///
  /// Returns `true` if all tabs and entries were successfully deleted, otherwise `false`.
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
