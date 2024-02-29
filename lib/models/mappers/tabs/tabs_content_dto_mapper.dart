import 'package:auto_mappr_annotation/auto_mappr_annotation.dart';
import 'package:multichoice/models/dto/tabs/tabs_dto.dart';
import 'package:multichoice/models/mappers/tabs/tabs_content_dto_mapper.auto_mappr.dart';

@AutoMappr([
  MapType<List<TabDTO>, TabsDTO>(
    fields: [
      Field('tabs', custom: TabsContentMapper.generateList),
    ],
  ),
])
class TabsContentMapper extends $TabsContentMapper {
  static List<TabDTO> generateList(List<TabDTO> content) {
    final tabs = <TabDTO>[];

    for (final contentItem in content) {
      tabs.add(contentItem);
    }
    return tabs;
  }
}
