import 'package:models/models.dart';
import 'package:dartz/dartz.dart';
import 'package:core/src/repositories/implementation/feedback/feedback_repository.dart';

abstract class IFeedbackRepository {
  Future<Either<FeedbackException, void>> submitFeedback(FeedbackDTO feedback);
  Stream<List<FeedbackDTO>> getFeedback();
}
