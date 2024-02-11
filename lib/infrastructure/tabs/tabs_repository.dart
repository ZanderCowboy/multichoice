import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart' as isar_db;
import 'package:multichoice/data/persistance/models/tabs_list.dart';
import 'package:multichoice/domain/tabs/i_tabs_repository.dart';
import 'package:multichoice/domain/tabs/models/tabs.dart';
import 'package:multichoice/utils/extensions/string.dart';
import 'package:uuid/uuid.dart';

@LazySingleton(as: ITabsRepository)
class TabsRepository implements ITabsRepository {
  TabsRepository(this.db);

  final tabsList = TabsList.instance;
  // final db = isar.Isar;

  @override
  Future<int> addTab(String title, String subtitle) async {
    // tabsList.addTab(
    //   Tabs(
    //     uuid: const Uuid().v4(),
    //     title: title,
    //     subtitle: subtitle,
    //   ),
    // );

    await db.writeTxn(() async {
      return db.tabs.put(
        Tabs(
          uuid: const Uuid().v4(),
          title: title,
          subtitle: subtitle,
        ),
      );
    });

    return 0;
  }

  @override
  Future<List<Tabs>> readTabs() async {
    // return tabsList.readTabs();

    return db.tabs.where().findAll();
  }

  @override
  Future<int> deleteTab(String tabId) async {
    tabsList.deleteTab(tabId);

    await db.writeTxn(() async {
      await db.tabs.delete(tabId.fastHash());
    });

    return 0;
  }

  final isar_db.Isar db;
  // final Isar db = await coreSl<DatabaseService>().isarDB;
  // late final IsarDB db;

  // @override
  // void initState() {
  //   this.db = coreSl<DatabaseService>().isarDB;
  // }
}
