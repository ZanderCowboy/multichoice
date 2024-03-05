import 'package:auto_mappr_annotation/auto_mappr_annotation.dart';
import 'package:models/models.dart';

import 'package:models/src/mappers/tabs/tabs_dto_mapper.auto_mappr.dart';

@AutoMappr([
  MapType<Tabs, TabsDTO>(
    fields: [
      Field('uuid', custom: TabsMapper.mapUuid),
      Field('title', custom: TabsMapper.mapTitle),
      Field('subtitle', custom: TabsMapper.mapSubtitle),
      Field('timestamp', custom: TabsMapper.mapTimestamp),
      Field('entryIds', custom: TabsMapper.mapEntryIds),
    ],
  ),
])
class TabsMapper extends $TabsMapper {
  static int mapUuid(Tabs content) => content.id;
  static String mapTitle(Tabs content) => content.title;
  static String mapSubtitle(Tabs content) => content.subtitle ?? '';
  static DateTime mapTimestamp(Tabs content) =>
      content.timestamp ?? DateTime.now();
  static List<int> mapEntryIds(Tabs content) => content.entryIds ?? [];
}
