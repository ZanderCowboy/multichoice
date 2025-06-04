// ignore_for_file: unused_field, unused_local_variable

import 'dart:developer';

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart' as isar;
import 'package:models/models.dart';
import 'package:uuid/uuid.dart';

@LazySingleton(as: IDemoRepository)
class DemoRepository implements IDemoRepository {
  DemoRepository(
    this.db,
    this._tabsRepository,
  );

  final isar.Isar db;
  final ITabsRepository _tabsRepository;

  @override
  Future<bool> loadDemoData() async {
    try {
      return await db.writeTxn(() async {
        final tabOneId = await db.tabs.put(
          Tabs(
            uuid: const Uuid().v4(),
            title: 'Dummy',
            subtitle: 'Some dummy',
            timestamp: DateTime.now(),
            entryIds: [],
          ),
        );

        final tabTwoId = await db.tabs.put(
          Tabs(
            uuid: const Uuid().v4(),
            title: 'Sunshine',
            subtitle: 'Moonshine',
            timestamp: DateTime.now(),
            entryIds: [],
          ),
        );

        return false;
      });
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
