import 'package:cloud_firestore/cloud_firestore.dart';
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

    group('submitFeedback', () {
      test('adds document to collection with correct data', () async {
        final mockDocRef = MockDocumentReference();
        when(mockCollection.add(any)).thenAnswer((_) async => mockDocRef);

        final result = await repository.submitFeedback(testFeedback);
        expect(result.isRight(), true);

        final captured = verify(mockCollection.add(captureAny)).captured;
        expect(captured.length, 1);
        final capturedData = captured.first;
        expect(capturedData, isA<Map<String, dynamic>>());
        expect(capturedData['message'], equals(testFeedback.message));
        expect(capturedData['rating'], equals(testFeedback.rating));
        expect(capturedData['deviceInfo'], equals(testFeedback.deviceInfo));
        expect(capturedData['appVersion'], equals(testFeedback.appVersion));
        expect(capturedData['userEmail'], equals(testFeedback.userEmail));
        expect(capturedData['category'], equals(testFeedback.category));
        expect(capturedData['status'], equals('pending'));
        expect(capturedData['timestamp'], isA<Timestamp>());
        expect(capturedData['userId'], equals(testFeedback.userId));
      });

      test('returns Left with FeedbackException on error', () async {
        when(mockCollection.add(any)).thenThrow(Exception('Firestore error'));

        final result = await repository.submitFeedback(testFeedback);
        expect(result.isLeft(), true);
        result.fold(
          (error) => expect(error, isA<FeedbackException>()),
          (_) => fail('Expected Left but got Right'),
        );
      });

      test('handles empty optional fields', () async {
        final mockDocRef = MockDocumentReference();
        when(mockCollection.add(any)).thenAnswer((_) async => mockDocRef);

        final feedbackWithEmptyFields = FeedbackDTO(
          id: '2',
          message: 'Test feedback',
          rating: 5,
          deviceInfo: 'Test Device',
          appVersion: '1.0.0',
          timestamp: DateTime.now(),
        );

        final result = await repository.submitFeedback(feedbackWithEmptyFields);
        expect(result.isRight(), true);

        final capturedData =
            verify(mockCollection.add(captureAny)).captured.first;
        expect(capturedData['userEmail'], isNull);
        expect(capturedData['category'], isNull);
        expect(capturedData['userId'], isNull);
      });
    });

    group('getFeedback', () {
      test('returns stream of feedback with correct mapping', () async {
        final mockDocs = [
          MockQueryDocumentSnapshot(),
          MockQueryDocumentSnapshot(),
        ];

        final mockData1 = {
          'message': 'Feedback 1',
          'rating': 4,
          'deviceInfo': 'Device 1',
          'appVersion': '1.0.0',
          'timestamp': Timestamp.now(),
          'userEmail': 'test1@example.com',
          'category': 'Bug',
          'status': 'pending',
        };

        final mockData2 = {
          'message': 'Feedback 2',
          'rating': 5,
          'deviceInfo': 'Device 2',
          'appVersion': '1.0.1',
          'timestamp': Timestamp.now(),
          'userEmail': 'test2@example.com',
          'category': 'Feature',
          'status': 'pending',
        };

        when(mockDocs[0].id).thenReturn('doc1');
        when(mockDocs[0].data()).thenReturn(mockData1);
        when(mockDocs[1].id).thenReturn('doc2');
        when(mockDocs[1].data()).thenReturn(mockData2);

        when(mockQuerySnapshot.docs).thenReturn(mockDocs);
        when(mockCollection.snapshots())
            .thenAnswer((_) => Stream.value(mockQuerySnapshot));

        final stream = repository.getFeedback();
        final feedbackList = await stream.first;

        expect(feedbackList, hasLength(2));
        expect(feedbackList[0].id, equals('doc1'));
        expect(feedbackList[0].message, equals('Feedback 1'));
        expect(feedbackList[0].rating, equals(4));
        expect(feedbackList[1].id, equals('doc2'));
        expect(feedbackList[1].message, equals('Feedback 2'));
        expect(feedbackList[1].rating, equals(5));
      });

      test('handles empty documents in stream', () async {
        when(mockQuerySnapshot.docs).thenReturn([]);
        when(mockCollection.snapshots())
            .thenAnswer((_) => Stream.value(mockQuerySnapshot));

        final stream = repository.getFeedback();
        final feedbackList = await stream.first;

        expect(feedbackList, isEmpty);
      });

      test('handles stream errors', () async {
        when(mockCollection.snapshots())
            .thenAnswer((_) => Stream.error(Exception('Stream error')));

        final stream = repository.getFeedback();
        expect(stream, emitsError(isA<Exception>()));
      });
    });
  });
}
