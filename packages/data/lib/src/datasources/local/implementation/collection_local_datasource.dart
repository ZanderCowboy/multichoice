import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:isar/isar.dart';

class CollectionLocalDatasource implements ICollectionLocalDatasource {
  CollectionLocalDatasource(this._databaseWrapper);

  final IDatabaseWrapper _databaseWrapper;

  @override
  Future<void> createCollection(CollectionModel collection) async {
    try {
      await _databaseWrapper.transaction(() async {
        _databaseWrapper.collections.put(collection);
      });
    } on IsarError catch (e) {
      throw DatabaseException('Failed to create collection: ${e.message}');
    } catch (e) {
      throw UnknownDatabaseException(
          'Unexpected error creating collection: $e');
    }
  }

  @override
  Future<void> deleteCollection(CollectionModel collection) async {
    try {
      await _databaseWrapper.transaction(() async {
        _databaseWrapper.collections.delete(collection.id);
      });
    } on IsarError catch (e) {
      throw DatabaseException('Failed to delete collection: ${e.message}');
    } catch (e) {
      throw UnknownDatabaseException(
          'Unexpected error deleting collection: $e');
    }
  }

  @override
  Future<CollectionModel> getCollection(int id) async {
    try {
      final result = await _databaseWrapper.collections.get(id);
      if (result == null) {
        throw CollectionNotFoundException('Collection with id $id not found');
      }
      return result;
    } on IsarError catch (e) {
      throw DatabaseException('Failed to get collection: ${e.message}');
    } catch (e) {
      throw UnknownDatabaseException('Unexpected error getting collection: $e');
    }
  }

  @override
  Future<List<CollectionModel>> getCollections() async {
    try {
      return await _databaseWrapper.collections.where().findAll();
    } on IsarError catch (e) {
      throw DatabaseException('Failed to get collections: ${e.message}');
    } catch (e) {
      throw UnknownDatabaseException(
          'Unexpected error getting collections: $e');
    }
  }

  @override
  Future<void> updateCollection(CollectionModel collection) async {
    try {
      await _databaseWrapper.transaction(() async {
        _databaseWrapper.collections.put(collection);
      });
    } on IsarError catch (e) {
      throw DatabaseException('Failed to update collection: ${e.message}');
    } catch (e) {
      throw UnknownDatabaseException(
          'Unexpected error updating collection: $e');
    }
  }
}
