import 'package:cloud_firestore/cloud_firestore.dart'
    show DocumentSnapshot, Timestamp;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'feedback_model.freezed.dart';
part 'feedback_model.g.dart';

@freezed
class FeedbackModel with _$FeedbackModel {
  const factory FeedbackModel({
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
  }) = _FeedbackModel;

  factory FeedbackModel.fromJson(Map<String, dynamic> json) =>
      _$FeedbackModelFromJson(json);
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
