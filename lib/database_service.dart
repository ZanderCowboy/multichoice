import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:multichoice/domain/entry/models/entry.dart';
import 'package:multichoice/domain/tabs/models/tabs.dart';
import 'package:path_provider/path_provider.dart';

abstract class DatabaseService {
  DatabaseService._internal();

  static final DatabaseService _instance = _instance;

  static DatabaseService get instance => _instance;

  final Map<Tabs, List<Entry>> _database = {}; // Private constructor

  Map<Tabs, List<Entry>> get database => _database;

  Future<Isar> get isar async => _initializeDB();

  Future<Isar> _initializeDB() async {
    final directory = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      [
        TabsSchema,
        EntrySchema,
      ],
      directory: directory.path,
      name: 'MultichoiceDB',
    );

    return isar;
  }
}
