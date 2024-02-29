import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart' as isar;
import 'package:multichoice/models/database/export_database.dart';
import 'package:multichoice/models/dto/tabs/tabs_dto.dart';
import 'package:multichoice/models/mappers/tabs/tabs_content_dto_mapper.dart';
import 'package:multichoice/models/mappers/tabs/tabs_dto_mapper.dart';
import 'package:multichoice/repositories/interfaces/tabs/i_tabs_repository.dart';
import 'package:uuid/uuid.dart';

@LazySingleton(as: ITabsRepository)
class TabsRepository implements ITabsRepository {
  TabsRepository(this.db);

  final isar.Isar db;

  @override
  Future<int> addTab(String title, String subtitle) async {
    try {
      await db.writeTxn(() async {
        final result = db.tabs.put(
          Tabs(
            uuid: const Uuid().v4(),
            title: title,
            subtitle: subtitle,
            timestamp: DateTime.now(),
          ),
        );

        return result;
      });
    } catch (e) {
      log(e.toString());
      return 0;
    }

    return 0;
  }

  @override
  Future<TabsDTO> readTabs() async {
    try {
      final result = await db.tabs.where().sortByTimestamp().findAll();

      final converter = TabsMapper();
      final dtos =
          result.map((tab) => converter.convert<Tabs, TabDTO>(tab)).toList();

      final tabsConverter = TabsContentMapper();
      final tabs = tabsConverter.convert<List<TabDTO>, TabsDTO>(dtos);

      return tabs;
    } catch (e) {
      log(e.toString());
      return const TabsDTO(tabs: []);
    }
  }

  @override
  Future<int> updateTab(int id, String title, String subtitle) async {
    try {
      await db.writeTxn(() async {
        final tab = await db.tabs.get(id);

        final newTab = tab?.copyWith(title: title, subtitle: subtitle);

        final result = await db.tabs.put(newTab!);

        // await db.tabs.delete(id);

        return result;
      });
    } catch (e) {
      log(e.toString());
    }
    return -1;
  }

  @override
  Future<bool> deleteTab(int tabId) async {
    try {
      await db.writeTxn(() async {
        final entries = await db.entrys.where().findAll();

        final tabEntries =
            entries.where((element) => element.tabId == tabId).toList();

        for (final element in tabEntries) {
          await db.entrys.delete(element.id);
        }

        final result = db.tabs.delete(tabId);

        return result;
      });
    } catch (e) {
      log(e.toString());
    }

    return false;
  }

  @override
  Future<TabDTO> getTab(int tabId) async {
    try {
      final tabs = await db.tabs.where().findAll();
      final result = tabs.firstWhere((element) => element.id == tabId);

      final dto = TabsMapper().convert<Tabs, TabDTO>(result);

      return dto;
    } catch (e) {
      log(e.toString());
      return TabDTO.empty();
    }
  }
}
