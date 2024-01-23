import 'package:multichoice/domain/tabs/models/tabs.dart';

abstract class ITabsRepository {
  Future<int> addTab(Tabs tab);

  List<Tabs> readTabs();

  Future<int> deleteTab(String tabId);
}
