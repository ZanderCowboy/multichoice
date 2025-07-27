import 'package:data/data.dart';
import 'package:data/src/mappers/export.dart';
import 'package:domain/domain.dart';

class ItemRepository implements IItemRepository {
  ItemRepository(this._localDatasource);

  final IItemLocalDatasource _localDatasource;

  @override
  Future<void> createItem(Item item) {
    final itemModel = ItemMapper().convert<Item, ItemModel>(item);
    return _localDatasource.createItem(itemModel);
  }

  @override
  Future<void> deleteItem(Item item) {
    final itemModel = ItemMapper().convert<Item, ItemModel>(item);
    return _localDatasource.deleteItem(itemModel);
  }

  @override
  Future<List<Item>> getItems() {
    return _localDatasource.getItems().then((items) => items
        .map((item) => ItemModelMapper().convert<ItemModel, Item>(item))
        .toList());
  }

  @override
  Future<Item> getItem(int id) {
    return _localDatasource
        .getItem(id)
        .then((item) => ItemModelMapper().convert<ItemModel, Item>(item));
  }

  @override
  Future<void> updateItem(Item item) {
    final itemModel = ItemMapper().convert<Item, ItemModel>(item);
    return _localDatasource.updateItem(itemModel);
  }
}
