import 'package:freezed_annotation/freezed_annotation.dart';

part 'entry_dto.freezed.dart';
part 'entry_dto.g.dart';

@freezed
class EntryDTO with _$EntryDTO {
  const factory EntryDTO({
    required int id,
    required int tabId,
    required String title,
    required String subtitle,
    required DateTime timestamp,
  }) = _EntryDTO;

  factory EntryDTO.empty() => EntryDTO(
        id: 0,
        tabId: 0,
        title: '',
        subtitle: '',
        timestamp: DateTime.now(),
      );

  factory EntryDTO.fromJson(Map<String, dynamic> json) =>
      _$EntryDTOFromJson(json);
}
