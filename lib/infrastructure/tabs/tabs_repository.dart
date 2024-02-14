import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart' as isar;
import 'package:multichoice/domain/export_domain.dart';
import 'package:multichoice/domain/tabs/i_tabs_repository.dart';
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
  Future<List<Tabs>> readTabs() async {
    try {
      final result = db.tabs.where().findAll();

      return result;
    } catch (e) {
      log(e.toString());
      return [];
    }
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
}
