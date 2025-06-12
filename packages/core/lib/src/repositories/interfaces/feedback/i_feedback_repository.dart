import 'package:models/models.dart';

abstract class IFeedbackRepository {
  Future<void> submitFeedback(FeedbackDTO feedback);
  Stream<List<FeedbackDTO>> getFeedback();
}
