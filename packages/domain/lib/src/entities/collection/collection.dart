import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'collection.freezed.dart';

@freezed
class Collection with _$Collection {
  factory Collection({
    required int id,
    required List<Item> items,
    required String title,
    required String subtitle,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Collection;

  factory Collection.empty() => Collection(
        id: 0,
        items: [],
        title: '',
        subtitle: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
}
