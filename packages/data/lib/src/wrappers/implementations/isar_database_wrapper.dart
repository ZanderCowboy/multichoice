import 'package:data/data.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarDatabaseWrapper implements IDatabaseWrapper {
  IsarDatabaseWrapper(this._database);

  Isar _database;

  @override
  Future<void> initialize() async {
    final directory = await getApplicationDocumentsDirectory();
    _database = await Isar.open(
      [
        CollectionModelSchema,
        ItemModelSchema,
      ],
      directory: directory.path,
      name: 'MultichoiceDB',
    );
  }

  @override
  Future<void> close() async {
    await _database.close();
  }

  @override
  Future<bool> isOpen() async {
    return _database.isOpen;
  }

  @override
  Future<T> transaction<T>(Future<T> Function() action) async {
    return _database.writeTxn(() => action());
  }

  @override
  IsarCollection<CollectionModel> get collections => _database.collectionModels;

  @override
  IsarCollection<ItemModel> get items => _database.itemModels;
}
