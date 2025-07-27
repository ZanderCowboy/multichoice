import 'package:auto_mappr_annotation/auto_mappr_annotation.dart';
import 'package:data/data.dart';
import 'package:data/src/mappers/collection/collection_model_mapper.auto_mappr.dart';
import 'package:domain/domain.dart';

@AutoMappr([
  MapType<CollectionModel, Collection>(
    fields: [
      Field('id', custom: CollectionModelMapper.mapId),
      Field('items', custom: CollectionModelMapper.mapItems),
      Field('title', custom: CollectionModelMapper.mapTitle),
      Field('subtitle', custom: CollectionModelMapper.mapSubtitle),
      Field('createdAt', custom: CollectionModelMapper.mapCreatedAt),
      Field('updatedAt', custom: CollectionModelMapper.mapUpdatedAt),
    ],
  ),
])
class CollectionModelMapper extends $CollectionModelMapper {
  static int mapId(CollectionModel model) => model.id;

  static List<Item> mapItems(CollectionModel model) =>
      model.itemIds.map((id) => Item.empty().copyWith(id: id)).toList();

  static String mapTitle(CollectionModel model) => model.title ?? '';

  static String mapSubtitle(CollectionModel model) => model.subtitle ?? '';

  static DateTime mapCreatedAt(CollectionModel model) =>
      model.createdAt ?? DateTime.now();

  static DateTime mapUpdatedAt(CollectionModel model) =>
      model.updatedAt ?? DateTime.now();
}
