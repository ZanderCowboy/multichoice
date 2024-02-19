import 'package:freezed_annotation/freezed_annotation.dart';

part 'tabs_dto.freezed.dart';
part 'tabs_dto.g.dart';

@freezed
class TabsDTO with _$TabsDTO {
  factory TabsDTO({
    required int id,
    required String title,
    required String subtitle,
    required DateTime timestamp,
  }) = _TabsDTO;

  factory TabsDTO.empty() => TabsDTO(
        id: 0,
        title: '',
        subtitle: '',
        timestamp: DateTime.now(),
      );

  factory TabsDTO.fromJson(Map<String, dynamic> json) =>
      _$TabsDTOFromJson(json);
}
