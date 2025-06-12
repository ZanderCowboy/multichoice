import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:models/models.dart';

@LazySingleton(as: IFeedbackRepository)
class FeedbackRepository implements IFeedbackRepository {
  final FirebaseFirestore _firestore;
  final String _collection = 'feedback';
  final FeedbackMapper _mapper = FeedbackMapper();

  FeedbackRepository(this._firestore);

  @override
  Future<void> submitFeedback(FeedbackDTO feedback) async {
    try {
      final model = _mapper.convert<FeedbackDTO, FeedbackModel>(feedback);
      await _firestore.collection(_collection).add(model.toFirestore());
    } catch (e) {
      throw Exception('Failed to submit feedback: $e');
    }
  }

  @override
  Stream<List<FeedbackDTO>> getFeedback() {
    return _firestore
        .collection(_collection)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => FeedbackModelFirestoreX.fromFirestore(doc))
          .map((model) => _mapper.convert<FeedbackModel, FeedbackDTO>(model))
          .toList();
    });
  }
}
