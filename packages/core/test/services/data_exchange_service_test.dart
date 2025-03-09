import 'dart:convert';
import 'dart:typed_data';
import 'package:core/src/services/implementations/data_exchange_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:mockito/mockito.dart';
import 'package:models/models.dart';

import '../injection.dart';
import '../mocks.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DataExchangeService dataExchangeService;
  late MockFilePickerWrapper mockFilePickerWrapper;
  late Isar db;

  setUpAll(() async {
    db = await configureTestCoreDependencies();
    mockFilePickerWrapper = MockFilePickerWrapper();
    dataExchangeService = DataExchangeService(
      db,
      filePickerWrapper: mockFilePickerWrapper,
    );
  });

  group('DataExchangeService', () {
    group('pickFile', () {
      test('should return file path when a file is selected', () async {
        final filePath = '/path/to/selected/file.txt';

        when(mockFilePickerWrapper.pickFile())
            .thenAnswer((_) async => filePath);

        final result = await dataExchangeService.pickFile();

        expect(result, filePath);
        verify(mockFilePickerWrapper.pickFile()).called(1);
      });

      test('should return null when no file is selected', () async {
        when(mockFilePickerWrapper.pickFile()).thenAnswer((_) async => null);

        final result = await dataExchangeService.pickFile();

        expect(result, isNull);
        verify(mockFilePickerWrapper.pickFile()).called(1);
      });
    });

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

    group('exportDataToJSON', () {
      final tabs1 = Tabs.empty().copyWith(
        uuid: 'test',
        title: 'First',
        subtitle: 'Second',
        entryIds: [590699460983228343, 590700560494856554],
      );
      final tabs2 = Tabs.empty().copyWith(
        uuid: 'moon',
        title: 'Donkey',
        subtitle: 'Dog',
        entryIds: null,
      );
      final entry1 = Entry.empty().copyWith(
        uuid: '1',
        tabId: 2715383224155124699,
        title: 'hello',
      );
      final entry2 = Entry.empty().copyWith(
        uuid: '2',
        tabId: 2715383224155124699,
        title: 'bye',
      );

      final mockTabs = [tabs1, tabs2];
      final mockEntries = [entry1, entry2];

      final resultTabs = [tabs1, tabs2];
      final resultEntries = [entry2, entry1];

      test('should export data to JSON successfully', () async {
        // Arrange
        await db.writeTxn(() async {
          db.clear();
          await db.tabs.putAll(mockTabs);
          await db.entrys.putAll(mockEntries);
        });
        final expectedJson = jsonEncode({
          'tabs': resultTabs.map((item) => item.toJson()).toList(),
          'entries': resultEntries.map((item) => item.toJson()).toList(),
        });

        // Act
        final json = await dataExchangeService.exportDataToJSON();

        // Assert
        expect(json, expectedJson);
      });

      test('should handle empty database', () async {
        // Arrange
        await db.writeTxn(() async {
          await db.clear();
        });

        // Act
        final json = await dataExchangeService.exportDataToJSON();

        // Assert
        final expectedJson = jsonEncode({
          'tabs': <Tabs>[],
          'entries': <Entry>[],
        });

        expect(json, expectedJson);
      });
    });

    group('importDataFromJSON', () {
      test('should import data from JSON successfully', () async {
        // Arrange
        final filePath = 'assets/test_data/import_file.json';

        // Act
        final result = await dataExchangeService.importDataFromJSON(filePath);

        // Assert
        expect(result, true);

        final tabs = await db.tabs.where().findAll();
        final entries = await db.entrys.where().findAll();

        expect(tabs.length, 2);
        expect(entries.length, 2);
      });

      test('should handle error during import', () async {
        final filePath = '/path/to/nonexistent/file.json';

        final result = await dataExchangeService.importDataFromJSON(filePath);

        expect(result, false);
      });
    });

    group('isDBEmpty', () {
      test('test name', () async {
        // Arrange
        await db.writeTxn(() => db.clear());

        // Act
        final result = await dataExchangeService.isDBEmpty();

        // Assert
        expect(result, true);
      });
    });
  });
}
