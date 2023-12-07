import 'package:multichoice/presentation/home/home_page.dart';

abstract class ITabsRepository {
  Future<void> addTab(VerticalTab verticalTab);

  List<VerticalTab> readTabs();

  Future<void> deleteTab(int tabIndex, VerticalTab verticalTab);
}
