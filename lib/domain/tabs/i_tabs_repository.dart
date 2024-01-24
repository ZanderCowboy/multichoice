import 'package:multichoice/domain/tabs/models/tabs.dart';

abstract class ITabsRepository {
  Future<int> addTab(String title, String subtitle);

  List<Tabs> readTabs();

  List<Tabs> updateTabs(int oldIndex, int newIndex);

  Future<int> deleteTab(String tabId);
}
