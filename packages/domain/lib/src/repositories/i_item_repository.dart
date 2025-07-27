import 'package:domain/domain.dart';

abstract class IItemRepository {
  Future<List<Item>> getItems();
  Future<Item> getItem(int id);
  Future<void> createItem(Item item);
  Future<void> updateItem(Item item);
  Future<void> deleteItem(Item item);
}
