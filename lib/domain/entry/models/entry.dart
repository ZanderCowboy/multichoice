import 'package:freezed_annotation/freezed_annotation.dart';

part 'entry.freezed.dart';

@freezed
class Entry with _$Entry {
  const factory Entry({
    required String uuid,
    required String tabId,
    required String title,
    required String subtitle,
  }) = _Entry;

  const Entry._();

  factory Entry.empty() => const Entry(
        uuid: '',
        tabId: '',
        title: '',
        subtitle: '',
      );

  String get id => uuid;
}
