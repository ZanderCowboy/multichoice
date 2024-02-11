import 'package:multichoice/domain/tabs/models/tabs.dart';

abstract class ITabsRepository {
  Future<int> addTab(String title, String subtitle);

  Future<List<Tabs>> readTabs();

  Future<int> deleteTab(String tabId);
  // Future<int> deleteTab(int tabId);
}
