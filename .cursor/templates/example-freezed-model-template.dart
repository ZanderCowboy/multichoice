// Template for creating a new Freezed model
// Copy this file and replace <ModelName> with your actual model name
// Run: melos build_runner to generate code

import 'package:freezed_annotation/freezed_annotation.dart';

part '<model_name>.freezed.dart';
part '<model_name>.g.dart';

@freezed
class <ModelName> with _$<ModelName> {
  const factory <ModelName>({
    required String id,
    // Add your fields here
    String? optionalField,
  }) = _<ModelName>;

  factory <ModelName>.fromJson(Map<String, dynamic> json) =>
      _$<ModelName>FromJson(json);
}
