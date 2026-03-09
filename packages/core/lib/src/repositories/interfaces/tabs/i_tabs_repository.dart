import 'package:models/models.dart';

abstract class ITabsRepository {
  Future<int> addTab({
    required String? title,
    required String? subtitle,
  });

  Future<TabsDTO> getTab({required int tabId});

  Future<List<TabsDTO>> readTabs();

  Future<int> updateTab({
    required int id,
    required String title,
    required String subtitle,
  });

  Future<bool> deleteTab({required int? tabId});

  Future<bool> deleteTabs();

  Future<bool> updateTabsOrder(List<int> tabIds);
}
