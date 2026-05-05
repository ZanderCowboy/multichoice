import 'package:auto_mappr_annotation/auto_mappr_annotation.dart';
import 'package:data/data.dart';
import 'package:data/src/mappers/collection/collection_mapper.auto_mappr.dart';
import 'package:domain/domain.dart';

@AutoMappr([
  MapType<Collection, CollectionModel>(),
])
class CollectionMapper extends $CollectionMapper {}
