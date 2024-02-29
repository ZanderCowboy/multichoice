import 'package:multichoice/models/dto/export_dto.dart';

abstract class DatabaseService {
  DatabaseService._internal();

  static final DatabaseService _instance = _instance;

  static DatabaseService get instance => _instance;

  final Map<TabsDTO, List<EntryDTO>> _database = {};

  Map<TabsDTO, List<EntryDTO>> get database => _database;
}
