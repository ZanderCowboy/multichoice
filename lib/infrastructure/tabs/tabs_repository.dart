import 'package:injectable/injectable.dart';
import 'package:multichoice/data/persistance/models/tabs_list.dart';
import 'package:multichoice/domain/tabs/i_tabs_repository.dart';
import 'package:multichoice/domain/tabs/models/tabs.dart';

@LazySingleton(as: ITabsRepository)
class TabsRepository implements ITabsRepository {
  TabsRepository();

  final tabsList = TabsList.instance;

  @override
  Future<int> addTab(Tabs tab) async {
    tabsList.addTab(tab);

    return 0;
  }

  @override
  Future<int> deleteTab(String tabId) async {
    tabsList.deleteTab(tabId);

    return 0;
  }

  @override
  List<Tabs> readTabs() {
    return tabsList.readTabs();
  }
}
