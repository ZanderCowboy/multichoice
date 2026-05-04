import 'package:cloud_firestore/cloud_firestore.dart'
    show DocumentSnapshot, Timestamp;
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'feedback_model.g.dart';

@CopyWith()
@JsonSerializable()
class FeedbackModel extends Equatable {
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
    this.imageUrls,
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
  final List<String>? imageUrls;

  Map<String, dynamic> toJson() => _$FeedbackModelToJson(this);

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
    imageUrls,
  ];
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
      imageUrls: (data['imageUrls'] as List<dynamic>?)?.map((e) => e as String).toList(),
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
      if (imageUrls != null) 'imageUrls': imageUrls,
    };
  }
}
