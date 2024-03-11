import 'package:models/models.dart';

abstract class IDatabaseService {
  Map<Tabs, List<Entry>> get database;
}
