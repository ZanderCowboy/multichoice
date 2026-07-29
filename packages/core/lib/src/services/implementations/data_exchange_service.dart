import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:isar_community/isar.dart';
import 'dart:convert';

import 'package:models/models.dart';

@LazySingleton(as: IDataExchangeService)
class DataExchangeService implements IDataExchangeService {
  static const String multichoiceExtension = 'multichoice';

  final Isar isar;
  final IFilePickerWrapper filePickerWrapper;

  DataExchangeService(
    this.isar, {
    required this.filePickerWrapper,
  });

  @override
  Future<String?> pickFile() async {
    return await filePickerWrapper.pickFile(
      allowedExtensions: const [
        multichoiceExtension,
        'json',
      ],
    );
  }

  @override
  Future<void> saveFile(String fileName, Uint8List fileBytes) async {
    try {
      final String? filePath = await filePickerWrapper.saveFile(
        dialogTitle: 'Save Multichoice File',
        fileName: '$fileName.$multichoiceExtension',
        bytes: fileBytes,
      );

      if (filePath != null) {
        File file = File(filePath);
        await file.writeAsBytes(fileBytes);
        print("File saved successfully at: $filePath");
      } else {
        print("User canceled file selection.");
      }
    } catch (e) {
      print("Error saving file: $e");
    }
  }

  @override
  Future<String> exportDataToJSON() async {
    final tabsData = await isar.tabs.where().findAll();
    final entriesData = await isar.entrys.where().findAll();

    final json = jsonEncode({
      'tabs': tabsData.map((item) => item.toJson()).toList(),
      'entries': entriesData.map((item) => item.toJson()).toList(),
    });

    return json;
  }

  @override
  Future<bool?> importDataFromJSON(
    String filePath, {
    bool shouldAppend = true,
  }) async {
    try {
      if (!_isSupportedImportFilePath(filePath)) {
        return false;
      }

      final file = await _getFile(filePath);

      if (file == null) {
        return false;
      }

      final jsonData = await file.readAsString();
      final decoded = jsonDecode(jsonData);
      if (decoded is! Map<String, dynamic>) {
        return false;
      }
      final data = decoded;

      final tabsRaw = data['tabs'];
      final entriesRaw = data['entries'];
      if (tabsRaw is! List || entriesRaw is! List) {
        return false;
      }

      final List<Map<String, dynamic>> tabsData = tabsRaw
          .whereType<Map<String, dynamic>>()
          .toList(growable: false);
      final List<Map<String, dynamic>> entriesData = entriesRaw
          .whereType<Map<String, dynamic>>()
          .toList(growable: false);

      if (tabsData.length != tabsRaw.length ||
          entriesData.length != entriesRaw.length) {
        return false;
      }

      await isar.writeTxn(() async {
        final newTabs = tabsData.map((e) => Tabs.fromJson(e)).toList();
        final newEntries = entriesData.map((e) => Entry.fromJson(e)).toList();

        if (!shouldAppend) {
          await isar.clear();
        }

        await isar.tabs.putAll(newTabs);
        await isar.entrys.putAll(newEntries);
      });

      return true;
    } catch (e, s) {
      log(
        e.toString(),
        error: e,
        stackTrace: s,
      );
      return false;
    }
  }

  bool _isSupportedImportFilePath(String filePath) {
    final lower = filePath.toLowerCase();
    return lower.endsWith('.$multichoiceExtension') || lower.endsWith('.json');
  }

  Future<File?> _getFile(String filePath) async {
    try {
      final file = File(filePath);

      if (await file.exists()) {
        return file;
      }
    } catch (e, s) {
      log(
        e.toString(),
        error: e,
        stackTrace: s,
      );
    }
    return null;
  }

  @override
  Future<bool> isDBEmpty() async {
    final tabsData = await isar.tabs.where().findAll();
    final entriesData = await isar.entrys.where().findAll();

    return tabsData.isEmpty && entriesData.isEmpty;
  }
}
