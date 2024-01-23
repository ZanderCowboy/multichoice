import 'package:multichoice/domain/entry/models/entry.dart';
import 'package:multichoice/domain/tabs/models/tabs.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static DatabaseService get instance => _instance;

  final Map<Tabs, List<Entry>> _database = {};

  DatabaseService._internal(); // Private constructor

  Map<Tabs, List<Entry>> get database => _database;
}
