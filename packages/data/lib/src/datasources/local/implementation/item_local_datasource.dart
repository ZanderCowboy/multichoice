import 'package:data/data.dart';
import 'package:isar/isar.dart';

class ItemLocalDatasource implements IItemLocalDatasource {
  ItemLocalDatasource(this._databaseWrapper);

  final IDatabaseWrapper _databaseWrapper;

  @override
  Future<void> createItem(ItemModel item) async {
    await _databaseWrapper.transaction(() async {
      _databaseWrapper.items.put(item);
    });
  }

  @override
  Future<void> deleteItem(ItemModel item) async {
    await _databaseWrapper.transaction(() async {
      _databaseWrapper.items.delete(item.id);
    });
  }

  @override
  Future<List<ItemModel>> getItems() async {
    return _databaseWrapper.items.where().findAll();
  }

  @override
  Future<ItemModel> getItem(int id) async {
    return await _databaseWrapper.items.get(id) ?? ItemModel.empty();
  }

  @override
  Future<void> updateItem(ItemModel item) async {
    await _databaseWrapper.transaction(() async {
      _databaseWrapper.items.put(item);
    });
  }
}
