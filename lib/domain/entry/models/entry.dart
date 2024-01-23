import 'package:freezed_annotation/freezed_annotation.dart';

part 'entry.freezed.dart';

@freezed
class Entry with _$Entry {
  const factory Entry({
    required String id,
    required String tabId,
    required String title,
    required String subtitle,
  }) = _Entry;

  factory Entry.empty() => const Entry(
        id: '',
        tabId: '',
        title: '',
        subtitle: '',
      );
}
