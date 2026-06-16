// Freezed model template
// Path: packages/models/lib/src/<area>/<model_name>.dart
// Export from the appropriate models export.dart barrel.
// Run: make db

import 'package:freezed_annotation/freezed_annotation.dart';

part '<model_name>.freezed.dart';
part '<model_name>.g.dart';

@freezed
class <ModelName> with _$<ModelName> {
  const factory <ModelName>({
    required String id,
    String? optionalField,
  }) = _<ModelName>;

  factory <ModelName>.fromJson(Map<String, dynamic> json) =>
      _$<ModelName>FromJson(json);
}
