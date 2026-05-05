import 'package:auto_mappr_annotation/auto_mappr_annotation.dart';
import 'package:data/data.dart';
import 'package:data/src/mappers/item/item_mapper.auto_mappr.dart';
import 'package:domain/domain.dart';

@AutoMappr([
  MapType<Item, ItemModel>(),
])
class ItemMapper extends $ItemMapper {}
