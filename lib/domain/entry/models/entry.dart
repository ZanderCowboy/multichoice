import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';
import 'package:multichoice/utils/extensions/string.dart';

part 'entry.freezed.dart';
part 'entry.g.dart';

@freezed
@Collection(ignore: {'copyWith'})
class Entry with _$Entry {
  factory Entry({
    required String uuid,
    required int tabId,
    required String title,
    required String subtitle,
  }) = _Entry;

  Entry._();

  factory Entry.empty() => Entry(
        uuid: '',
        tabId: 0,
        title: '',
        subtitle: '',
      );

  factory Entry.fromJson(Map<String, dynamic> json) => _$EntryFromJson(json);

  Id get id => uuid.fastHash();
}
