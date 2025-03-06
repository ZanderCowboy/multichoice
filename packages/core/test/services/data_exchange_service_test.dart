import 'dart:typed_data';
import 'package:core/src/services/implementations/data_exchange_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks.mocks.dart';

void main() {
  late DataExchangeService dataExchangeService;
  late MockIsar mockIsar;
  late MockFilePickerWrapper mockFilePickerWrapper;

  setUp(() {
    mockIsar = MockIsar();
    mockFilePickerWrapper = MockFilePickerWrapper();
    dataExchangeService = DataExchangeService(
      mockIsar,
      filePickerWrapper: mockFilePickerWrapper,
    );
  });

  group('DataExchangeService', () {
    group('saveFile', () {
      test('should save file successfully', () async {
        final fileName = 'testFile';
        final fileBytes = Uint8List.fromList([0, 1, 2, 3, 4, 5]);
        final filePath = '/path/to/save/testFile.json';

        when(mockFilePickerWrapper.saveFile(
          dialogTitle: anyNamed('dialogTitle'),
          fileName: anyNamed('fileName'),
          bytes: anyNamed('bytes'),
        )).thenAnswer((_) async => filePath);

        await dataExchangeService.saveFile(fileName, fileBytes);

        verify(mockFilePickerWrapper.saveFile(
          dialogTitle: 'Save JSON File',
          fileName: '$fileName.json',
          bytes: fileBytes,
        )).called(1);
      });

      test('should handle user canceling file selection', () async {
        final fileName = 'testFile';
        final fileBytes = Uint8List.fromList([0, 1, 2, 3, 4, 5]);

        when(mockFilePickerWrapper.saveFile(
          dialogTitle: anyNamed('dialogTitle'),
          fileName: anyNamed('fileName'),
          bytes: anyNamed('bytes'),
        )).thenAnswer((_) async => null);

        await dataExchangeService.saveFile(fileName, fileBytes);

        verify(mockFilePickerWrapper.saveFile(
          dialogTitle: 'Save JSON File',
          fileName: '$fileName.json',
          bytes: fileBytes,
        )).called(1);
      });

      test('should handle error during file saving', () async {
        final fileName = 'testFile';
        final fileBytes = Uint8List.fromList([0, 1, 2, 3, 4, 5]);

        when(mockFilePickerWrapper.saveFile(
          dialogTitle: anyNamed('dialogTitle'),
          fileName: anyNamed('fileName'),
          bytes: anyNamed('bytes'),
        )).thenThrow(Exception('Error saving file'));

        await dataExchangeService.saveFile(fileName, fileBytes);

        verify(mockFilePickerWrapper.saveFile(
          dialogTitle: 'Save JSON File',
          fileName: '$fileName.json',
          bytes: fileBytes,
        )).called(1);
      });
    });
  });
}
