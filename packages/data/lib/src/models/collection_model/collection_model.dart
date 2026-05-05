import 'package:data/src/extensions/string.dart';
import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'collection_model.g.dart';

@Collection(ignore: {'copyWith'})
@JsonSerializable()
class CollectionModel {
  CollectionModel({
    required this.uuid,
    required this.title,
    required this.subtitle,
    required this.createdAt,
    required this.updatedAt,
    required this.itemUuids,
  });

  factory CollectionModel.empty() => CollectionModel(
        uuid: null,
        title: null,
        subtitle: null,
        createdAt: null,
        updatedAt: null,
        itemUuids: null,
      );

  factory CollectionModel.fromJson(Map<String, dynamic> json) =>
      _$CollectionModelFromJson(json);

  final String? uuid;
  final String? title;
  final String? subtitle;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<String>? itemUuids;

  Map<String, dynamic> toJson() => _$CollectionModelToJson(this);

  Id get id => uuid?.fastHash() ?? 0;

  List<int> get itemIds => itemUuids?.map((id) => id.fastHash()).toList() ?? [];
}
