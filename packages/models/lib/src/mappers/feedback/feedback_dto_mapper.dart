import 'package:auto_mappr_annotation/auto_mappr_annotation.dart';
import 'package:models/models.dart';

import 'package:models/src/mappers/feedback/feedback_dto_mapper.auto_mappr.dart';

@AutoMappr([
  MapType<FeedbackModel, FeedbackDTO>(
    fields: [
      Field('id'),
      Field('message'),
      Field('rating'),
      Field('deviceInfo'),
      Field('appVersion'),
      Field('timestamp'),
      Field('userId'),
      Field('userEmail'),
      Field('category'),
      Field('status'),
    ],
  ),
  MapType<FeedbackDTO, FeedbackModel>(
    fields: [
      Field('id'),
      Field('message'),
      Field('rating'),
      Field('deviceInfo'),
      Field('appVersion'),
      Field('timestamp'),
      Field('userId'),
      Field('userEmail'),
      Field('category'),
      Field('status'),
    ],
  ),
])
class FeedbackMapper extends $FeedbackMapper {}
