import 'package:models/models.dart';

abstract class ITabsRepository {
  Future<int> addTab(String title, String subtitle);

  Future<TabDTO> getTab(int tabId);

  Future<TabsDTO> readTabs();

  Future<int> updateTab(int id, String title, String subtitle);

  Future<TabsDTO> getTab(int tabId);

  Future<bool> deleteTab(int? tabId);
}
