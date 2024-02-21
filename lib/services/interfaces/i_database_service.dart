abstract class DatabaseService {
  DatabaseService._internal();

  static final DatabaseService _instance = _instance;

  static DatabaseService get instance => _instance;

  // final Map<Tabs, List<Entry>> _database = {};
  final Map<String, String> _database = {};

  // Map<Tabs, List<Entry>> get database => _database;
  Map<String, String> get database => _database;
}
