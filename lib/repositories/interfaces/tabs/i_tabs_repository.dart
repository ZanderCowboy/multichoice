import 'package:multichoice/models/dto/tabs/tabs_dto.dart';

abstract class ITabsRepository {
  Future<int> addTab(String title, String subtitle);

  Future<List<TabsDTO>> readTabs();

  Future<TabsDTO> getTab(int tabId);

  Future<bool> deleteTab(int tabId);
}
