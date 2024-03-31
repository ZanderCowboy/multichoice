import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';
import 'package:models/src/dto/extensions/string.dart';

part 'entry.freezed.dart';
part 'entry.g.dart';

@freezed
@Collection(ignore: {'copyWith'})
class Entry with _$Entry {
  factory Entry({
    required String uuid,
    required int tabId,
    required String title,
    required String? subtitle,
    required DateTime? timestamp,
  }) = _Entry;

  Entry._();

  factory Entry.empty() => Entry(
        uuid: '',
        tabId: 0,
        title: '',
        subtitle: null,
        timestamp: null,
      );

  factory Entry.fromJson(Map<String, dynamic> json) => _$EntryFromJson(json);

  Id get id => uuid.fastHash();
}
