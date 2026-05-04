import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'feedback_dto.g.dart';

@CopyWith()
@JsonSerializable()
class FeedbackDTO extends Equatable {
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
    rating: 1,
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
  List<Object?> get props => [
    id,
    message,
    rating,
    deviceInfo,
    appVersion,
    timestamp,
    userId,
    userEmail,
    category,
    status,
  ];
}
