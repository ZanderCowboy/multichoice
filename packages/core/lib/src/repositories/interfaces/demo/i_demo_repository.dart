import 'package:models/models.dart';

abstract class IDemoRepository {
  Future<List<TabsDTO>> loadDemoTabs();
}
