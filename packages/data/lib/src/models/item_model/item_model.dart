import 'package:data/src/extensions/string.dart';
import 'package:isar/isar.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_model.freezed.dart';
part 'item_model.g.dart';

@freezed
@Collection(ignore: {'copyWith'})
class ItemModel with _$ItemModel {
  factory ItemModel({
    required String? uuid,
    required String? collectionUuid,
    required String? title,
    required String? subtitle,
    required DateTime? createdAt,
    required DateTime? updatedAt,
  }) = _ItemModel;

  const ItemModel._();

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

  Id get id => uuid?.fastHash() ?? 0;

  int get collectionId => collectionUuid?.fastHash() ?? 0;
}
