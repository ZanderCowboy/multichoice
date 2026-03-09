import 'package:models/src/enums/analytics/export.dart';

class ScreenViewEventData {
  const ScreenViewEventData({
    required this.page,
    this.previousPage,
  });

  final AnalyticsPage page;
  final AnalyticsPage? previousPage;
}
