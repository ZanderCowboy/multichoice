import 'package:data/data.dart';
import 'package:data/src/mappers/export.dart';
import 'package:domain/domain.dart';

class CollectionRepository implements ICollectionRepository {
  CollectionRepository(this._localDatasource);

  final ICollectionLocalDatasource _localDatasource;

  @override
  Future<void> createCollection(Collection collection) async {
    try {
      // Business validation
      if (collection.title.trim().isEmpty) {
        throw ValidationException('Collection title cannot be empty');
      }

      if (collection.title.length > 255) {
        throw ValidationException(
            'Collection title cannot exceed 255 characters');
      }

      final collectionModel =
          CollectionMapper().convert<Collection, CollectionModel>(collection);
      await _localDatasource.createCollection(collectionModel);
    } on ValidationException {
      rethrow; // Let business errors bubble up
    } on DatabaseException {
      rethrow; // Let infrastructure errors bubble up
    } catch (e) {
      throw RepositoryException('Failed to create collection: $e');
    }
  }

  @override
  Future<void> deleteCollection(Collection collection) async {
    try {
      final collectionModel =
          CollectionMapper().convert<Collection, CollectionModel>(collection);
      await _localDatasource.deleteCollection(collectionModel);
    } on DatabaseException {
      rethrow; // Let infrastructure errors bubble up
    } catch (e) {
      throw RepositoryException('Failed to delete collection: $e');
    }
  }

  @override
  Future<Collection> getCollection(int id) async {
    try {
      if (id <= 0) {
        throw ValidationException('Collection ID must be positive');
      }

      final collectionModel = await _localDatasource.getCollection(id);
      return CollectionModelMapper()
          .convert<CollectionModel, Collection>(collectionModel);
    } on ValidationException {
      rethrow; // Let business errors bubble up
    } on CollectionNotFoundException {
      rethrow; // Let not found errors bubble up
    } on DatabaseException {
      rethrow; // Let infrastructure errors bubble up
    } catch (e) {
      throw RepositoryException('Failed to get collection: $e');
    }
  }

  @override
  Future<List<Collection>> getCollections() async {
    try {
      final collectionModels = await _localDatasource.getCollections();
      return collectionModels
          .map((collection) => CollectionModelMapper()
              .convert<CollectionModel, Collection>(collection))
          .toList();
    } on DatabaseException {
      rethrow; // Let infrastructure errors bubble up
    } catch (e) {
      throw RepositoryException('Failed to get collections: $e');
    }
  }

  @override
  Future<void> updateCollection(Collection collection) async {
    try {
      // Business validation
      if (collection.title.trim().isEmpty) {
        throw ValidationException('Collection title cannot be empty');
      }

      if (collection.title.length > 255) {
        throw ValidationException(
            'Collection title cannot exceed 255 characters');
      }

      final collectionModel =
          CollectionMapper().convert<Collection, CollectionModel>(collection);
      await _localDatasource.updateCollection(collectionModel);
    } on ValidationException {
      rethrow; // Let business errors bubble up
    } on DatabaseException {
      rethrow; // Let infrastructure errors bubble up
    } catch (e) {
      throw RepositoryException('Failed to update collection: $e');
    }
  }
}
