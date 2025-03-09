import 'dart:typed_data';

import 'package:core/src/wrappers/implementations/file_picker_wrapper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FilePickerWrapper', () {
    late MockFilePicker mockFilePicker;
    late FilePickerWrapper filePickerWrapper;

    setUpAll(() {
      mockFilePicker = MockFilePicker();
      filePickerWrapper = FilePickerWrapper(filePicker: mockFilePicker);
    });

    group('pickFile', () {
      test('should pick a file successfully', () async {
        // Arrange
        final filePath = 'path/to/file.txt';
        when(mockFilePicker.pickFiles()).thenAnswer(
          (_) async => FilePickerResult(
            [
              PlatformFile(
                name: 'file.txt',
                path: filePath,
                size: 0,
              ),
            ],
          ),
        );

        // Act
        final result = await filePickerWrapper.pickFile();

        // Assert
        expect(result, filePath);
        verify(mockFilePicker.pickFiles()).called(1);
      });

      test('should return null when no file is picked', () async {
        // Arrange
        when(mockFilePicker.pickFiles()).thenAnswer((_) async => null);

        // Act
        final result = await filePickerWrapper.pickFile();

        // Assert
        expect(result, isNull);
        verify(mockFilePicker.pickFiles()).called(1);
      });
    });

    group('saveFile', () {
      test('should save a file successfully', () async {
        // Arrange
        final dialogTitle = 'Save File';
        final fileName = 'file.txt';
        final filePath = 'path/to/file.txt';
        final bytes = Uint8List(0);
        when(mockFilePicker.saveFile(
          dialogTitle: dialogTitle,
          fileName: fileName,
          bytes: bytes,
        )).thenAnswer((_) async => filePath);

        // Act
        final result = await filePickerWrapper.saveFile(
          dialogTitle: dialogTitle,
          fileName: fileName,
          bytes: bytes,
        );

        // Assert
        expect(result, filePath);
        verify(mockFilePicker.saveFile(
          dialogTitle: dialogTitle,
          fileName: fileName,
          bytes: bytes,
        )).called(1);
      });

      test('should return null when save file is cancelled', () async {
        // Arrange
        final dialogTitle = 'Save File';
        final fileName = 'file.txt';
        final bytes = Uint8List(0);
        when(mockFilePicker.saveFile(
          dialogTitle: dialogTitle,
          fileName: fileName,
          bytes: bytes,
        )).thenAnswer((_) async => null);

        // Act
        final result = await filePickerWrapper.saveFile(
          dialogTitle: dialogTitle,
          fileName: fileName,
          bytes: bytes,
        );

        // Assert
        expect(result, isNull);
        verify(mockFilePicker.saveFile(
          dialogTitle: dialogTitle,
          fileName: fileName,
          bytes: bytes,
        )).called(1);
      });
    });
  });
}
