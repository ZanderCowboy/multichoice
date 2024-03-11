import 'package:models/models.dart';

abstract class ITabsRepository {
  Future<int> addTab(String title, String subtitle);

  Future<TabsDTO> getTab(int tabId);

  Future<List<TabsDTO>> readTabs();

  Future<int> updateTab(int id, String title, String subtitle);

  Future<bool> deleteTab(int? tabId);

  Future<bool> deleteTabs();
}
