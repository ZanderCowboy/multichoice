import 'package:auto_mappr_annotation/auto_mappr_annotation.dart';
import 'package:models/models.dart';

import 'package:models/src/mappers/entry/entry_dto_mapper.auto_mappr.dart';

@AutoMappr([
  MapType<Entry, EntryDTO>(
    fields: [
      Field('uuid', custom: EntryMapper.mapUuid),
      Field('tabId', custom: EntryMapper.mapTabId),
      Field('title', custom: EntryMapper.mapTitle),
      Field('subtitle', custom: EntryMapper.mapSubtitle),
      Field('timestamp', custom: EntryMapper.mapTimestamp),
    ],
  ),
])
class EntryMapper extends $EntryMapper {
  static int mapUuid(Entry content) => content.id;
  static int mapTabId(Entry content) => content.tabId;
  static String mapTitle(Entry content) => content.title;
  static String mapSubtitle(Entry content) => content.subtitle ?? '';
  static DateTime mapTimestamp(Entry content) =>
      content.timestamp ?? DateTime.now();
}
