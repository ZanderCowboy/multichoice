import 'package:freezed_annotation/freezed_annotation.dart';

part 'tabs_dto.freezed.dart';
part 'tabs_dto.g.dart';

@freezed
class TabsDTO with _$TabsDTO {
  const factory TabsDTO({
    required List<TabDTO>? tabs,
  }) = _TabsDTO;

  factory TabsDTO.empty() => const TabsDTO(tabs: null);

  factory TabsDTO.fromJson(Map<String, dynamic> json) =>
      _$TabsDTOFromJson(json);
}

@freezed
class TabDTO with _$TabDTO {
  const factory TabDTO({
    required int id,
    required String title,
    required String subtitle,
    required DateTime timestamp,
  }) = _TabDTO;

  factory TabDTO.empty() => TabDTO(
        id: 0,
        title: '',
        subtitle: '',
        timestamp: DateTime.now(),
      );

  factory TabDTO.fromJson(Map<String, dynamic> json) => _$TabDTOFromJson(json);
}
