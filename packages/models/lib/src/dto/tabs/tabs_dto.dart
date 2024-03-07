import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:models/src/dto/export_dto.dart';

part 'tabs_dto.freezed.dart';
part 'tabs_dto.g.dart';

@freezed
class TabsDTO with _$TabsDTO {
  factory TabsDTO({
    required int id,
    required String title,
    required String subtitle,
    required DateTime timestamp,
    required List<EntryDTO> entries,
  }) = _TabsDTO;

  factory TabsDTO.empty() => TabsDTO(
        id: 0,
        title: '',
        subtitle: '',
        timestamp: DateTime.now(),
        entries: [],
      );

  factory TabsDTO.fromJson(Map<String, dynamic> json) =>
      _$TabsDTOFromJson(json);
}
