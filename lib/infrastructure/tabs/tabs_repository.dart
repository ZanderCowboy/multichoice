import 'package:injectable/injectable.dart';
import 'package:multichoice/data/persistance/models/tabs_list.dart';
import 'package:multichoice/domain/tabs/i_tabs_repository.dart';
import 'package:multichoice/presentation/home/home_page.dart';

@LazySingleton(as: ITabsRepository)
class TabsRepository implements ITabsRepository {
  TabsRepository();

  TabsList tabsList = TabsList();

  @override
  Future<void> addTab(VerticalTab verticalTab) async {
    tabsList.addTab(verticalTab);
  }

  @override
  List<VerticalTab> readTabs() {
    return tabsList.readTabs();
  }

  @override
  void deleteTab(int index) {
    tabsList.deleteTab(index);
  }
}
