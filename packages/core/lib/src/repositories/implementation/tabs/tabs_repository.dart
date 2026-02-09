import 'dart:developer';

import 'package:core/src/repositories/interfaces/tabs/i_tabs_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:isar_community/isar.dart' as isar;
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
  Future<int> addTab({
    required String? title,
    required String? subtitle,
  }) async {
    try {
      return await db.writeTxn(() async {
        // Get the maximum order value to set the new tab's order
        final tabs = await db.tabs.where().findAll();
        final maxOrder = tabs.isEmpty 
            ? -1 
            : tabs.map((t) => t.order).reduce((a, b) => a > b ? a : b);
        
        final result = db.tabs.put(
          Tabs(
            uuid: const Uuid().v4(),
            title: title ?? '',
            subtitle: subtitle,
            timestamp: clock.now(),
            entryIds: [],
            order: maxOrder + 1,
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
      var tabs = await db.tabs.where().sortByOrder().findAll();
      
      // Migration: Check if multiple tabs have the same order (e.g., all 0)
      // This can happen when upgrading from a version without the order field
      final orderCounts = <int, int>{};
      for (final tab in tabs) {
        orderCounts[tab.order] = (orderCounts[tab.order] ?? 0) + 1;
      }
      
      // If we detect duplicate orders, reassign based on timestamp
      final hasDuplicateOrders = orderCounts.values.any((count) => count > 1);
      if (hasDuplicateOrders) {
        await _migrateTabOrders(tabs);
        // Re-fetch tabs after migration
        tabs = await db.tabs.where().sortByOrder().findAll();
      }

      final tabsConverter = TabsMapper();
      final entryConverter = EntryMapper();

      final result = <TabsDTO>[];
      for (final tab in tabs) {
        final tabDTO = tabsConverter.convert<Tabs, TabsDTO>(tab);
        final entryIds = tab.entryIds ?? [];

        // Optimize: Use bulk read instead of individual gets
        final entries = await db.entrys.getAll(entryIds);
        final entriesDTO = entries
            .where((entry) => entry != null)
            .map((entry) => entryConverter.convert<Entry, EntryDTO>(entry!))
            .toList();

        final newTabDTO = tabDTO.copyWith(entries: entriesDTO);
        result.add(newTabDTO);
      }

      return result;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }
  
  /// Migrates tab orders by assigning sequential order values based on timestamp.
  /// This is needed when upgrading from a version without the order field.
  Future<void> _migrateTabOrders(List<Tabs> tabs) async {
    try {
      await db.writeTxn(() async {
        // Sort by timestamp to preserve the original creation order
        final sortedTabs = List<Tabs>.from(tabs)
          ..sort((a, b) => (a.timestamp ?? DateTime.now())
              .compareTo(b.timestamp ?? DateTime.now()));
        
        // Reassign order values starting from 0
        for (int i = 0; i < sortedTabs.length; i++) {
          final updatedTab = sortedTabs[i].copyWith(order: i);
          await db.tabs.put(updatedTab);
        }
      });
      log('Migrated ${tabs.length} tabs to use proper order values');
    } catch (e) {
      log('Error migrating tab orders: $e');
    }
  }

  /// Retrieves a specific tab by its [int] ID.
  ///
  /// [tabId]: The ID of the tab to retrieve.
  ///
  /// Returns a [TabsDTO] representing the tab, or an empty [TabsDTO] if an error occurs.
  @override
  Future<TabsDTO> getTab({required int tabId}) async {
    try {
      final tabs = await db.tabs.where().findAll();
      final result = tabs.firstWhere((element) => element.id == tabId);

      final dto = TabsMapper().convert<Tabs, TabsDTO>(result);
      final entryIds = result.entryIds ?? [];

      // Optimize: Use bulk read instead of individual gets
      final entries = await db.entrys.getAll(entryIds);
      final entriesDTO = entries
          .where((entry) => entry != null)
          .map((entry) => EntryMapper().convert<Entry, EntryDTO>(entry!))
          .toList();

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
  Future<int> updateTab({
    required int id,
    required String title,
    required String subtitle,
  }) async {
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
  Future<bool> deleteTab({required int? tabId}) async {
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

  /// Updates the order of tabs in the database.
  ///
  /// [tabIds]: The list of tab IDs in the new order.
  ///
  /// Returns `true` if the tabs were successfully reordered, otherwise `false`.
  @override
  Future<bool> updateTabsOrder(List<int> tabIds) async {
    try {
      return await db.writeTxn(() async {
        // Optimize: Use bulk read instead of individual gets
        final tabs = await db.tabs.getAll(tabIds);
        final updatedTabs = <Tabs>[];
        
        for (int i = 0; i < tabs.length; i++) {
          final tab = tabs[i];
          if (tab != null) {
            final updatedTab = tab.copyWith(order: i);
            updatedTabs.add(updatedTab);
          }
        }
        
        // Optimize: Use bulk write instead of individual puts
        await db.tabs.putAll(updatedTabs);
        return true;
      });
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
