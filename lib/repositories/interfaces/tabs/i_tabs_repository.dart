import 'package:multichoice/models/dto/tabs/tabs_dto.dart';

abstract class ITabsRepository {
  Future<int> addTab(String title, String subtitle);

  Future<TabDTO> getTab(int tabId);

  Future<TabsDTO> readTabs();

  Future<int> updateTab(int id, String title, String subtitle);

  Future<bool> deleteTab(int tabId);
}
