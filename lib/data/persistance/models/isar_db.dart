import 'package:multichoice/data/persistance/models/i_isar_db.dart';
import 'package:multichoice/domain/export_domain.dart';

// TODO(@ZanderCowboy): This can be removed, since it is no longer needed

class IsarDB implements IIsarDB {
  IsarDB._();
  static final IsarDB _instance = IsarDB._();
  static IsarDB get instance => _instance;

  // static final isar = coreSl<DatabaseService>().isar;

  @override
  int addEntryToTab(String tabId, Entry entryCard) {
    // TODO: implement addEntryToTab
    throw UnimplementedError();
  }

  @override
  // Future<int> addTab (Tabs tab) async {
  //   await isar.writeTxn(() async {});
  // }

  @override
  int deleteEntryInTab(String tabId, String entryId) {
    // TODO: implement deleteEntryInTab
    throw UnimplementedError();
  }

  @override
  int deleteTab(String tabId) {
    // TODO: implement deleteTab
    throw UnimplementedError();
  }

  @override
  List<Entry>? readEntries(String tabId) {
    // TODO: implement readEntries
    throw UnimplementedError();
  }

  @override
  List<Tabs> readTabs() {
    // TODO: implement readTabs
    throw UnimplementedError();
  }

  @override
  int addTab(Tabs tab) {
    // TODO: implement addTab
    throw UnimplementedError();
  }
}
