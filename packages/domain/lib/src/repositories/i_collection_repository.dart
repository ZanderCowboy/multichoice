import 'package:domain/domain.dart';

abstract class ICollectionRepository {
  Future<List<Collection>> getCollections();
  Future<Collection> getCollection(int id);
  Future<void> createCollection(Collection collection);
  Future<void> updateCollection(Collection collection);
  Future<void> deleteCollection(Collection collection);
}
