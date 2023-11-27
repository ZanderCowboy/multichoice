import 'package:multichoice/presentation/home/home_page.dart';

class TabsList {
  TabsList();

  static final List<VerticalTab> tabsList = [];

  // create
  void addTab(VerticalTab verticalTab) {
    tabsList.add(verticalTab);
  }

  // read
  List<VerticalTab> readTabs() {
    return tabsList;
  }

  // update

  // delete
  void deleteTab(int index) {
    tabsList.removeAt(index);
  }
}
