import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:models/models.dart';

abstract class IFeedbackRepository {
  Future<void> submitFeedback(FeedbackModel feedback);
  Stream<List<FeedbackModel>> getFeedback();
}

@LazySingleton(as: IFeedbackRepository)
class FeedbackRepository implements IFeedbackRepository {
  final FirebaseFirestore _firestore;
  final String _collection = 'feedback';

  FeedbackRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> submitFeedback(FeedbackModel feedback) async {
    try {
      await _firestore.collection(_collection).add(feedback.toFirestore());
    } catch (e) {
      throw Exception('Failed to submit feedback: $e');
    }
  }

  @override
  Stream<List<FeedbackModel>> getFeedback() {
    return _firestore
        .collection(_collection)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => FeedbackModelFirestoreX.fromFirestore(doc))
          .toList();
    });
  }
}
