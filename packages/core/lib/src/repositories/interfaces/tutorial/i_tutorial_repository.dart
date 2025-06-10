import 'package:models/models.dart';

abstract class ITutorialRepository {
  Future<List<TabsDTO>> loadTutorialData();
}
