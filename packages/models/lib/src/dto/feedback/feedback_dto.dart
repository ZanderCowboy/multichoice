import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'feedback_dto.g.dart';

@CopyWith()
@JsonSerializable()
class FeedbackDTO {
  const FeedbackDTO({
    required this.id,
    required this.message,
    required this.rating,
    required this.deviceInfo,
    required this.appVersion,
    required this.timestamp,
    this.userId,
    this.userEmail,
    this.category,
    this.status = 'pending',
  });

  factory FeedbackDTO.empty() => FeedbackDTO(
    id: '',
    message: '',
    rating: 0,
    deviceInfo: '',
    appVersion: '',
    timestamp: DateTime.now(),
  );

  factory FeedbackDTO.fromJson(Map<String, dynamic> json) =>
      _$FeedbackDTOFromJson(json);

  final String id;
  final String message;
  final int rating;
  final String deviceInfo;
  final String appVersion;
  final DateTime timestamp;
  final String? userId;
  final String? userEmail;
  final String? category;
  final String status;

  Map<String, dynamic> toJson() => _$FeedbackDTOToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeedbackDTO &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          message == other.message &&
          rating == other.rating &&
          deviceInfo == other.deviceInfo &&
          appVersion == other.appVersion &&
          timestamp == other.timestamp &&
          userId == other.userId &&
          userEmail == other.userEmail &&
          category == other.category &&
          status == other.status;

  @override
  int get hashCode =>
      id.hashCode ^
      message.hashCode ^
      rating.hashCode ^
      deviceInfo.hashCode ^
      appVersion.hashCode ^
      timestamp.hashCode ^
      userId.hashCode ^
      userEmail.hashCode ^
      category.hashCode ^
      status.hashCode;

  @override
  String toString() =>
      'FeedbackDTO(id: $id, message: $message, rating: $rating, deviceInfo: $deviceInfo, appVersion: $appVersion, timestamp: $timestamp, userId: $userId, userEmail: $userEmail, category: $category, status: $status)';
}
