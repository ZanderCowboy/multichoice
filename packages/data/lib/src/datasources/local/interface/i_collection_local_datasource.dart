import 'package:data/data.dart';

abstract class ICollectionLocalDatasource {
  Future<void> createCollection(CollectionModel collection);
  Future<void> updateCollection(CollectionModel collection);
  Future<void> deleteCollection(CollectionModel collection);
  Future<CollectionModel> getCollection(int id);
  Future<List<CollectionModel>> getCollections();
}
