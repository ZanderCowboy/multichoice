import 'package:freezed_annotation/freezed_annotation.dart';

part 'item.freezed.dart';

@freezed
class Item with _$Item {
  factory Item({
    required int id,
    required int collectionId,
    required String title,
    required String subtitle,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Item;

  factory Item.empty() => Item(
        id: 0,
        collectionId: 0,
        title: '',
        subtitle: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
}
