import 'package:data/src/extensions/string.dart';
import 'package:isar/isar.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'collection_model.freezed.dart';
part 'collection_model.g.dart';

@freezed
@Collection(ignore: {'copyWith'})
class CollectionModel with _$CollectionModel {
  factory CollectionModel({
    required String? uuid,
    required String? title,
    required String? subtitle,
    required DateTime? createdAt,
    required DateTime? updatedAt,
    required List<String>? itemUuids,
  }) = _CollectionModel;

  const CollectionModel._();

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

  Id get id => uuid?.fastHash() ?? 0;

  List<int> get itemIds => itemUuids?.map((id) => id.fastHash()).toList() ?? [];
}
