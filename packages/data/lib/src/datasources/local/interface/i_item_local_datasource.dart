import 'package:data/data.dart';

abstract class IItemLocalDatasource {
  Future<void> createItem(ItemModel item);
  Future<void> updateItem(ItemModel item);
  Future<void> deleteItem(ItemModel item);
  Future<ItemModel> getItem(int id);
  Future<List<ItemModel>> getItems();
}
