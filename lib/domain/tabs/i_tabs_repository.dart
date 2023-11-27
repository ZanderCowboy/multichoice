import 'package:multichoice/presentation/home/home_page.dart';

abstract class ITabsRepository {
  Future<void> addTab(VerticalTab verticalTab);

  List<VerticalTab> readTabs();

  void deleteTab(int index);
}
