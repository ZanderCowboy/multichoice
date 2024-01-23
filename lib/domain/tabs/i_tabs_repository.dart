import 'package:multichoice/domain/tabs/models/tabs.dart';

abstract class ITabsRepository {
  Future<int> addTab(String title, String subtitle);

  List<Tabs> readTabs();

  Future<int> deleteTab(String tabId);
}
