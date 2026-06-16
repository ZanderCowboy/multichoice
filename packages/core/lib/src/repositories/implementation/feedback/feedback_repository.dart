import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:models/models.dart';
import 'package:dartz/dartz.dart';

class FeedbackException implements Exception {
  final String message;
  FeedbackException(this.message);

  @override
  String toString() => message;
}

@LazySingleton(as: IFeedbackRepository)
class FeedbackRepository implements IFeedbackRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final String _collection = 'feedback';
  final FeedbackMapper _mapper = FeedbackMapper();

  FeedbackRepository(this._firestore, this._storage);

  @override
  Future<Either<FeedbackException, void>> submitFeedback(
    FeedbackDTO feedback, {
    List<PlatformFile>? imageFiles,
  }) async {
    try {
      List<String> imageUrls = [];
      if (imageFiles != null && imageFiles.isNotEmpty) {
        for (var file in imageFiles) {
          final ref = _storage.ref().child(
            'feedback/${feedback.id}/${file.name}',
          );
          if (file.bytes != null) {
            await ref.putData(file.bytes!);
          } else if (file.path != null) {
            await ref.putFile(File(file.path!));
          }
          final url = await ref.getDownloadURL();
          imageUrls.add(url);
        }
      }

      final updatedFeedback = feedback.copyWith(imageUrls: imageUrls);
      final model = _mapper.convert<FeedbackDTO, FeedbackModel>(
        updatedFeedback,
      );
      await _firestore.collection(_collection).add(model.toFirestore());
      return const Right(null);
    } catch (e) {
      return Left(FeedbackException('Failed to submit feedback: $e'));
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
              .map(
                (model) => _mapper.convert<FeedbackModel, FeedbackDTO>(model),
              )
              .toList();
        });
  }
}
