import 'package:data/src/extensions/string.dart';
import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'item_model.g.dart';

@Collection(ignore: {'copyWith'})
@JsonSerializable()
class ItemModel {
  ItemModel({
    required this.uuid,
    required this.collectionUuid,
    required this.title,
    required this.subtitle,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ItemModel.empty() => ItemModel(
        uuid: null,
        collectionUuid: null,
        title: null,
        subtitle: null,
        createdAt: null,
        updatedAt: null,
      );

  factory ItemModel.fromJson(Map<String, dynamic> json) =>
      _$ItemModelFromJson(json);

  final String? uuid;
  final String? collectionUuid;
  final String? title;
  final String? subtitle;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() => _$ItemModelToJson(this);

  Id get id => uuid?.fastHash() ?? 0;

  int get collectionId => collectionUuid?.fastHash() ?? 0;
}
