import 'package:core/src/repositories/implementation/feedback/feedback_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:models/models.dart';

import '../../../../mocks.mocks.dart';

void main() {
  late FeedbackRepository repository;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference mockCollection;
  late MockQuerySnapshot mockQuerySnapshot;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference();
    mockQuerySnapshot = MockQuerySnapshot();

    when(mockFirestore.collection('feedback')).thenReturn(mockCollection);
    when(mockCollection.orderBy('timestamp', descending: true))
        .thenReturn(mockCollection);

    repository = FeedbackRepository(mockFirestore);
  });

  group('FeedbackRepository', () {
    final testFeedback = FeedbackDTO(
      id: '1',
      message: 'Test feedback',
      rating: 5,
      deviceInfo: 'Test Device',
      appVersion: '1.0.0',
      timestamp: DateTime.now(),
      userId: 'user1',
      userEmail: 'test@example.com',
      category: 'General Feedback',
    );

    test('submitFeedback adds document to collection', () async {
      final mockDocRef = MockDocumentReference();
      when(mockCollection.add(any)).thenAnswer((_) async => mockDocRef);

      await repository.submitFeedback(testFeedback);

      verify(mockCollection.add(any)).called(1);
    });

    test('submitFeedback throws exception on error', () async {
      when(mockCollection.add(any)).thenThrow(Exception('Firestore error'));

      expect(
        () => repository.submitFeedback(testFeedback),
        throwsException,
      );
    });

    test('getFeedback returns stream of feedback', () {
      final mockDocs = [
        MockQueryDocumentSnapshot(),
        MockQueryDocumentSnapshot(),
      ];

      when(mockQuerySnapshot.docs).thenReturn(mockDocs);
      when(mockCollection.snapshots())
          .thenAnswer((_) => Stream.value(mockQuerySnapshot));

      final stream = repository.getFeedback();
      expect(stream, isA<Stream<List<FeedbackDTO>>>());
    });
  });
}
