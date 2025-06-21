import 'package:freezed_annotation/freezed_annotation.dart';

part 'feedback_dto.freezed.dart';
part 'feedback_dto.g.dart';

@freezed
class FeedbackDTO with _$FeedbackDTO {
  const factory FeedbackDTO({
    required String id,
    required String message,
    required int rating,
    required String deviceInfo,
    required String appVersion,
    required DateTime timestamp,
    String? userId,
    String? userEmail,
    String? category,
    @Default('pending') String status,
  }) = _FeedbackDTO;

  factory FeedbackDTO.fromJson(Map<String, dynamic> json) =>
      _$FeedbackDTOFromJson(json);

  factory FeedbackDTO.empty() => FeedbackDTO(
        id: '',
        message: '',
        rating: 0,
        deviceInfo: '',
        appVersion: '',
        timestamp: DateTime.now(),
      );
}
