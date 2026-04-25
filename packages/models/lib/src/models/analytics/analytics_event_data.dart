import 'package:models/src/enums/analytics/export.dart';

abstract class AnalyticsEventData {
  const AnalyticsEventData();

  AnalyticsEventName get eventName;

  Map<AnalyticsParamKey, Object?> get parameters;

  Map<String, Object> toFirebaseParameters() {
    final params = <String, Object>{};

    for (final entry in parameters.entries) {
      final value = entry.value;
      if (value == null) {
        continue;
      }

      params[entry.key.key] = _normalizeValue(value);
    }

    return params;
  }

  Object _normalizeValue(Object value) {
    if (value is bool) {
      return value ? 'true' : 'false';
    }

    if (value is String || value is num) {
      return value;
    }

    return value.toString();
  }
}
