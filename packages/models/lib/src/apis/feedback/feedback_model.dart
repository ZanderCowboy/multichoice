import 'package:cloud_firestore/cloud_firestore.dart'
    show DocumentSnapshot, Timestamp;
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'feedback_model.g.dart';

@CopyWith()
@JsonSerializable()
class FeedbackModel {
  const FeedbackModel({
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

  factory FeedbackModel.fromJson(Map<String, dynamic> json) =>
      _$FeedbackModelFromJson(json);

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

  Map<String, dynamic> toJson() => _$FeedbackModelToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeedbackModel &&
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
      'FeedbackModel(id: $id, message: $message, rating: $rating, deviceInfo: $deviceInfo, appVersion: $appVersion, timestamp: $timestamp, userId: $userId, userEmail: $userEmail, category: $category, status: $status)';
}

extension FeedbackModelFirestoreX on FeedbackModel {
  static FeedbackModel fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return FeedbackModel(
      id: doc.id,
      message: data['message'] as String? ?? '',
      userId: data['userId'] as String?,
      userEmail: data['userEmail'] as String?,
      rating: data['rating'] as int? ?? 0,
      deviceInfo: data['deviceInfo'] as String? ?? '',
      appVersion: data['appVersion'] as String? ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      category: data['category'] as String?,
      status: data['status'] as String? ?? 'pending',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'message': message,
      'userId': userId,
      'userEmail': userEmail,
      'rating': rating,
      'deviceInfo': deviceInfo,
      'appVersion': appVersion,
      'timestamp': Timestamp.fromDate(timestamp),
      'category': category,
      'status': status,
    };
  }
}
