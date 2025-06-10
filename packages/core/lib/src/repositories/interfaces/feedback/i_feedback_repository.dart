import 'package:models/models.dart';

abstract class IFeedbackRepository {
  Future<void> submitFeedback(FeedbackModel feedback);
  Stream<List<FeedbackModel>> getFeedback();
}
