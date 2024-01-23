import 'package:injectable/injectable.dart';
import 'package:multichoice/data/persistance/models/tabs_list.dart';
import 'package:multichoice/domain/tabs/i_tabs_repository.dart';
import 'package:multichoice/domain/tabs/models/tabs.dart';
import 'package:uuid/uuid.dart';

@LazySingleton(as: ITabsRepository)
class TabsRepository implements ITabsRepository {
  TabsRepository();

  final tabsList = TabsList.instance;

  @override
  Future<int> addTab(String title, String subtitle) async {
    tabsList.addTab(
      Tabs(
        uuid: const Uuid().v4(),
        title: title,
        subtitle: subtitle,
      ),
    );

    return 0;
  }

  @override
  List<Tabs> readTabs() {
    return tabsList.readTabs();
  }

  @override
  Future<int> deleteTab(String tabId) async {
    tabsList.deleteTab(tabId);

    return 0;
  }
}
