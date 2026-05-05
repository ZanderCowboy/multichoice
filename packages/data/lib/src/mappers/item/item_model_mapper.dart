import 'package:auto_mappr_annotation/auto_mappr_annotation.dart';
import 'package:data/data.dart';
import 'package:data/src/mappers/item/item_model_mapper.auto_mappr.dart';
import 'package:domain/domain.dart';

@AutoMappr([
  MapType<ItemModel, Item>(
    fields: [
      Field('id', custom: ItemModelMapper.mapId),
      Field('collectionId', custom: ItemModelMapper.mapCollectionId),
      Field('title', custom: ItemModelMapper.mapTitle),
      Field('subtitle', custom: ItemModelMapper.mapSubtitle),
      Field('createdAt', custom: ItemModelMapper.mapCreatedAt),
      Field('updatedAt', custom: ItemModelMapper.mapUpdatedAt),
    ],
  ),
])
class ItemModelMapper extends $ItemModelMapper {
  static int mapId(ItemModel model) => model.id;

  static int mapCollectionId(ItemModel model) => model.collectionId;

  static String mapTitle(ItemModel model) => model.title ?? '';

  static String mapSubtitle(ItemModel model) => model.subtitle ?? '';

  static DateTime mapCreatedAt(ItemModel model) =>
      model.createdAt ?? DateTime.now();

  static DateTime mapUpdatedAt(ItemModel model) =>
      model.updatedAt ?? DateTime.now();
}
