import 'package:auto_mappr_annotation/auto_mappr_annotation.dart';
import 'package:models/models.dart';

import 'package:models/src/mappers/tabs/tabs_dto_mapper.auto_mappr.dart';

@AutoMappr([
  MapType<Tabs, TabsDTO>(
    fields: [
      Field('id', custom: TabsMapper.mapUuid),
      Field('title'),
      Field('subtitle', custom: TabsMapper.mapSubtitle),
      Field('timestamp', custom: TabsMapper.mapTimestamp),
      Field('entries', custom: TabsMapper.mapEntryIds),
      Field('order'),
    ],
  ),
])
class TabsMapper extends $TabsMapper {
  static int mapUuid(Tabs content) => content.id;
  static String mapSubtitle(Tabs content) => content.subtitle ?? '';
  static DateTime mapTimestamp(Tabs content) =>
      content.timestamp ?? DateTime.now();
  static List<EntryDTO> mapEntryIds(Tabs content) {
    return (content.entryIds ?? [])
        .map((id) => EntryDTO.empty().copyWith(id: id))
        .toList();
  }
}
