import 'package:isar/isar.dart';
import 'package:data/data.dart';

abstract class IDatabaseWrapper {
  Future<void> close();
  Future<void> initialize();
  Future<bool> isOpen();
  Future<T> transaction<T>(Future<T> Function() action);

  // Collection getters
  IsarCollection<CollectionModel> get collections;
  IsarCollection<ItemModel> get items;
}
