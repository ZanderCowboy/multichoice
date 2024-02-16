import 'package:multichoice/domain/export_domain.dart';

abstract class DatabaseService {
  DatabaseService._internal();

  static final DatabaseService _instance = _instance;

  static DatabaseService get instance => _instance;

  final Map<Tabs, List<Entry>> _database = {}; // Private constructor

  Map<Tabs, List<Entry>> get database => _database;

  // @preResolve
  // Future<Isar> get isar async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   final isar = await Isar.open(
  //     [
  //       TabsSchema,
  //       EntrySchema,
  //     ],
  //     directory: directory.path,
  //     name: 'MultichoiceDB',
  //   );

  //   return isar;
  // }
}
