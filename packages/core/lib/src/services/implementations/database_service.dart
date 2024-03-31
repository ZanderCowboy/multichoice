import 'package:core/core.dart';
import 'package:models/models.dart';

class DatabaseService implements IDatabaseService {
  DatabaseService._internal();

  static final DatabaseService _instance = _instance;

  static DatabaseService get instance => _instance;

  final Map<Tabs, List<Entry>> _database = {};

  @override
  Map<Tabs, List<Entry>> get database => _database;
}
