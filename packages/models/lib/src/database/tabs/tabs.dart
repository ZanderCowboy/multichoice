import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';
import 'package:models/src/dto/extensions/string.dart';

part 'tabs.freezed.dart';
part 'tabs.g.dart';

@freezed
@Collection(ignore: {'copyWith'})
class Tabs with _$Tabs {
  const factory Tabs({
    required String uuid,
    required String title,
    required String? subtitle,
    required DateTime? timestamp,
    required List<int>? entryIds,
  }) = _Tabs;

  const Tabs._();

  factory Tabs.empty() => const Tabs(
        uuid: '',
        title: '',
        subtitle: null,
        timestamp: null,
        entryIds: null,
      );

  factory Tabs.fromJson(Map<String, dynamic> json) => _$TabsFromJson(json);

  Id get id => uuid.fastHash();
}
